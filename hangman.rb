require 'sinatra'
require 'sinatra/reloader'

# word = contents.sample

# get '/' do
# 	@@turns = 5
# 	guess = params["guess"]
# 	message = check_guess(guess, word)
# 	letter = add_letter(message)
# 	erb :hangman_level, :locals => {:word => word, :letter => letter, :message => message}
# end

# def check_guess(guess, word)
# 	word = word.split
# 	if word.include?(guess)
# 		return letter
# 	else

# 	end
# end














# # # split_words.sort.join('|')

# # # { |file| file.readlines }
# def make_words
	file = File.open("enable.txt", "r") 
	contents = file.read.split
# 	split_words = []
# 	contents.each do |line|
# 		if !(split_words.include? line.split(''))
# 			split_words.push(line.split(''))
# 		end
# 	end
# 	return split_words
# 	# return contents
# end

# # all_words = make_words
turns = 5
word_length = 0 

get '/' do
	erb :hangman_level
end

get '/new/' do
	@@word = ""
	@@choice = params["level"]
	turns = change_turns(turns)
	# if turns == 4
		@@choice = params["level"]
		word_length = choose_difficulty(@@choice)
		guess = params["guess"]
		@@message = check_guesses(guess, @@word)
		@@word = answer(word_length, contents)
	# end 

	erb :hangman, :locals => {
		:turns => turns, 
		:word_length => word_length,
		# :level => level,
		:message => @@message, 
		:word => @@word}
end

# get '/' do
# 	level = params["level"]
# 	# erb :hangman_level, :locals => {:turns => turns}
# end


def choose_difficulty(choice)
	# choice = choice.chomp.downcase
	if choice == "easy"
		word_length = 3
	elsif choice == "medium"
		word_length = 10
	else
		word_length = 15
	end
end

def answer(word_length, all_words)
	possible_words = all_words.select { |line| line.chomp.length == word_length }
  
  @@word = possible_words.sample
  return @@word
end	


def change_turns(turns)
	if turns > 0
		turns -= 1
	else
		"Game Over"
		new_game
	end
end

def check_guesses(guess, word)
	# word = word.split('')
	# puts word

	# if word.include?(guess)
	# 	"There is a" + letter
	# else
	# 	"Guess Again"
	# end

	letters = []
	word = word.to_s.split('')
	# saves index number to display letter in view
	word.each_with_index do |x, i|
		letters << i if x == guess
	end
	letters.empty? ? nil : letters
end


def new_game
	turns = 5
end


# def check_guesses(guess, word)
# 	letters = []
# 	word = word.split('')
# 	word.each_with_index do |x, i|
# 		letters << i if x == guess
# 	end
# 	letters.empty? ? nil : letters
# end

