require 'sinatra'
require 'sinatra/reloader'

@contents = File.open("enable.txt", "r") { |file| file.read }

get '/' do
	puts "Choose level: Easy, Medium, or Hard"
	choice = gets.chomp.downcase
	difficulty = choose_difficulty(choice)
	word = rand(difficulty)
	print word
	erb :hangman, :locals => {:word => word}
end

def choose_difficulty(choice)
	if (choice == "easy")
		play_easy
	elsif choice == "medium"
		play_medium
	else
		play_hard
	end
end

def play_easy
	easy = []
	@contents.readlines do |line|
      easy.push(line) if line.count % 3 == 0
   end   
	puts easy
end

def play_medium
	medium = []
	@contents.readlines do |line|
      medium.push(line) if line.count % 5 == 0
  end   

	puts medium
end	

def play_hard
	hard = []
	@contents.readlines do |line|
      hard.push(line) if line.count % 10 == 0
  end   
	puts hard
end	