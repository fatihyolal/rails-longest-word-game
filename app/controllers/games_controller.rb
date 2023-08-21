require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(10) { alphabet.sample }
  end

  def score
    # raise
    @letters = params[:letters]
    @word = params[:word]

    # raise
    @valid_grid = word_valid_grid?(@word, @letters)
    @valid_word = word_valid_english?(@word)

    if @valid_grid && @valid_english
      @message = "Congratulations! #{@word} is a valid English word and can be built from the grid."
    elsif @valid_grid && !@valid_word
      @message = "#{@word} is a valid word on the grid, but it is not a valid English word."
    else
      @message = "#{@word} can't be built out of the original grid."
    end
  end

  private

  def word_valid_grid?(word, letters)
    return false if letters.nil?
    word_letters = word.upcase.chars
    grid_letters = letters.upcase
    word_letters.each do |letter| grid_letters.include?(letter) &&
      grid_letters.count(letter) >= word_letters.count(letter)
    end
  end

  def word_valid_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    parsed_word = JSON.parse(word_serialized)
    parsed_word["found"]
  end
end

# The word can’t be built out of the original grid
# The word is valid according to the grid, but is not a valid English word
# The word is valid according to the grid and is an English word
