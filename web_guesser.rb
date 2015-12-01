require 'sinatra'
require 'sinatra/reloader'

number = rand(100)

get '/' do
  guess = params["guess"]
  message = check_guess(guess, number)
 	color = change_background(message)
  erb :index, :locals => {:number => number, :color => color, :message => message}
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

def change_background(message)
	if message == "WAAAY too high!"
		color = 'red'
	elsif message == "Too high!"
		color = '#FFC0CB'
	elsif message == "Too low!"
		color = '#FFC0CB'
	elsif message == "WAAAY too low!"
		color = 'red'
	else
		color = 'green'
	end
		
end

