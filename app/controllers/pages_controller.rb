require 'open-uri'
require 'json'

class PagesController < ApplicationController

  def game
    all_letters = ("A".."Z").to_a
    voyels = ["A", "E", "I", "O", "U"]
    @my_letters = []
    @score = params["score"].to_i || 0

    7.times do
      @my_letters.push all_letters.sample(1).join
    end

    3.times do
      @my_letters.push voyels.sample(1).join
    end
  end

  def result

    @score = params["score"].to_i
    @my_letters = params["letters"].split("")
    @my_word = params["input"]
    @answer = ""
    @my_word_letters = @my_word.upcase.split("")
    @color=""

    @word_validation = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@my_word}").read)

      if !@word_validation["found"]
        @color="red"
        return @answer = "#{@my_word.upcase} is not an accepted word!"
      end

      @my_word_letters.map do |x|
      if @my_letters.include? x
        @my_letters -= [x]
        p @my_letters
      else
         @color="red"

        return @answer = "You use the wrong letters (#{x})"
      end
      @color="green"
      @answer = "The word is good! your score is #{@word_validation["length"]} points!"

    end
  end

end
