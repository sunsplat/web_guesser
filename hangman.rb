require 'sinatra'
require 'sinatra/reloader'

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



# { |file| file.readlines }

file = File.open("enable.txt", "r") 
@@contents = file.read.split

@@word_length = 0
@@turns = 0
@@dash = '-' 
@@current_string = '_' * @@word_length

get '/' do
	erb :hangman_level
end

post '/' do
	@@choice = params["level"]
	@@wrong_guess = []
	redirect '/new/' if @@choice
end

get '/new/' do #get setup
	@@word_length = choose_difficulty(@@choice)
	@@word = answer(@@word_length, @@contents)
	message = set_message(@@current_string, @@word)
	# @@turns = 5
	erb :hangman, :locals => {
		:turns => @@turns, 
		:message => message, 
		:word => @@word, 
		:turns => @@turns
	}
end

post '/new/' do
		# word_length = choose_difficulty(@@choice)
		guess = params["guess"]
		letter_index = check_guesses(guess, @@word)
		if letter_index.nil?
			@@wrong_guess.push(guess)
			@@turns += 1
		else
			@@current_string = show_dash(@@current_string, guess, letter_index)
		end
		message = check_win(@@current_string, @@word)

		# message = set_message(@@current_string, @@word)

	erb :hangman, :locals => {
		:turns => @@turns, 
		:word_length => @@word_length,
		:wrong_guess => @@wrong_guess,
		:dash => @@dash,
		:message => message, 
		:word => @@word
	}
end


def choose_difficulty(choice)
	# choice = choice.chomp.downcase
	if choice == "easy"
		word_length = 3

	elsif choice == "medium"
		word_length = 10
	else
		word_length = 15
	end
	return word_length
end

def answer(word_length, all_words)
	possible_words = all_words.select { |line| line.chomp.length == word_length }
  
  @@word = possible_words.sample
  return @@word
end	


def check_guesses(guess, word)
	letter_index = []
	word = word.split('')
	# saves index number to display letter in view
	word.each_with_index do |x, i|
		letter_index.push(i) if x == guess
	end
	letter_index.empty? ? nil : letter_index
end

def show_dash(current_string, guess, letter_index)
	current_string = current_string.to_s.split('')
	letter_index.each {|x| current_string[x] = guess}

	@@win = true if !current_string.include?('_')
	return current_string.join('')
end

def check_win(current_string, word)
	if current_string == word
		@@win == true
		message = "You guessed the word! Play again?"
	end

end


def new_game
	@@turns = 5
	guess = []
	@@word = ''
	@@win = false
	@@word_length = 0
	@@current_string = '-' * @@word_length
	redirect '/'
end


def set_message(guess, word)
	"Your guess is #{guess} and the word is #{word}"
end

