require 'open-uri'
require "json"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
    session[:letters] = @letters
  end

  def score
    @word = params[:word].upcase
    url = "https://dictionary.lewagon.com/#{params[:word]}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    letters = session[:letters]
    user_hash = @word.chars.tally
    letters_hash = letters.tally
    results = []
    user_hash.each do |key, value|
      if letters_hash[key].nil?
        results << false
      else
        result = letters_hash[key] >= value
        results << result
      end
    end

    if word["found"] && results.all?
      @result = "Congratulations! #{@word} is valid"
    elsif !results.all?
      @result = "You used letters outside of the grid"
    else
      @result = "#{@word} isn't a valid English word"
    end
  end
end
