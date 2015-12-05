require 'sinatra'
require 'sinatra/reloader'

# { |file| file.readlines }

file = File.open("enable.txt", "r") 
@@contents = file.read.split

# @@current_string = '_' * @@word_length

get '/' do
	enter_level = ''
	erb :hangman_level, :locals => {
		:enter_level => enter_level,
	}
end

post '/' do
	if params["level"] == ''
		enter_level = "Please enter a difficulty level"
		# redirect '/'
	else
		@@choice = params["level"]
		enter_level = ''
		@@wrong_guess = []
		@@win = false
		@@turns = 0
		redirect '/new/' if @@choice
	end
	erb :hangman_level, :locals => {
		:enter_level => enter_level,
	}
end

get '/new/' do #get setup
	@@try_again = ''
	@@word_length = choose_difficulty(@@choice)
	@@current_string = '_' * @@word_length
	@@word = answer(@@word_length, @@contents)

	erb :hangman, :locals => {
		:turns => @@turns, 
	}

end

post '/new/' do
	if params["guess"] == ''
		@@try_again = "Please guess a letter."
	elsif params["guess"].length != 1
		@@try_again = "Please guess one letter at a time."
	else
		guess = params["guess"]
		@@try_again = ''
		letter_index = check_guesses(guess, @@word)


		if letter_index.nil?
			if @@wrong_guess.include?(guess)
					@@try_again = "You already guessed that letter"
			else
				@@try_again = ''
				@@wrong_guess.push(guess)
				@@turns += 1
			end
		else
			@@current_string = show_dash(@@current_string, guess, letter_index)
		end

		if @@current_string == @@word
			redirect '/gameover/'
		end

		if @@turns == 5
			redirect '/gameover/'
		else
			check_win(@@current_string, @@word, @@turns)
		end
	end

	erb :hangman, :locals => {
		:try_again => @@try_again,
		:turns => @@turns, 
		:word_length => @@word_length,
		:wrong_guess => @@wrong_guess,
	}
end

get '/gameover/' do
	message = check_win(@@current_string, @@word, @@turns)
	erb :hangman_win, :locals => {:message => message}
end

# Returns an integer for the difficulty level user selected
def choose_difficulty(choice)
	choice = choice.downcase
	if choice == "easy"
		word_length = rand(3..5)
	elsif choice == "medium"
		word_length = rand(6..10)
	else
		word_length = rand(11..15)
	end

	return word_length

end

# Selects a random word from the imported dictionary
def answer(word_length, all_words)
	possible_words = all_words.select { |line| line.chomp.length == word_length }
  
  @@word = possible_words.sample
  return @@word
end	

# Finds the index number in the word for correctly guessed letter
def check_guesses(guess, word)
	guess = guess.downcase
	letter_index = []
	word = word.split('')
	# saves index number to display letter in view
	word.each_with_index do |x, i|
		letter_index.push(i) if x == guess
	end
	letter_index.empty? ? nil : letter_index
end

# Creates the word using dashes
def show_dash(current_string, guess, letter_index)
	guess = guess.downcase
	current_string = current_string.split('')
	letter_index.each {|x| current_string[x] = guess}

	@@win = true if !current_string.include?('_')
	return current_string.join('')
end

# Checks if the user guessed the word
def check_win(current_string, word, turns)
	if current_string == word && turns < 5
		message = "You guessed the word! Play again?"
	elsif current_string != word && turns == 5
		message = "Sorry, the word was #{word}. Play again?"
	else
		@@win == false
	end
end
