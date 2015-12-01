require 'sinatra'
require 'sinatra/reloader'

number = rand(100)

get '/' do
  guess = params["guess"]
  message = check_guess(guess, number)
  erb :index, :locals => {:number => number, :guess => guess, :message => message}
end

def check_guess(guess, number)
	if guess.to_i > (number + 5)
		"WAAAY too high!"
	elsif (number + 5) > guess.to_i  && guess.to_i > number
		"Too high!"
	elsif number > guess.to_i && guess.to_i > (number - 5)
		"Too low!"
	elsif number-5 > guess.to_i
		"WAAAY too low!"
	elsif guess.to_i == number
		"You got it right! The secret number is #{number}"		
	end
end

