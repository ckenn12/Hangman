require "csv"

INCORRCET_GUESS_MAX = 8

# Load viable words into array.
contents = File.readlines("./google-10000-english-no-swears.txt")
words = []
contents.each do |word|
  if word.delete!("\n").length.between?(5, 12)
    words.append(word)
  end 
end

def select_game_word(words)
  game_word = words.sample()
end 

def create_blanks_of_word(word)
  blanks = ""
  word.length.times do 
    blanks += "_"
  end
  blanks
end

def print_blanks(blanks)
  blanks.each_char do |blank|
    print(blank + " ")
  end
  print("\n")
end


def get_guess(guessed_letters)
  puts "Enter your single letter guess."
  while true
    guess = gets.chomp.downcase
    if guess.length == 1 && guess.match?(/[[:alpha:]]/) && guessed_letters.include?(guess).!
      guessed_letters += guess
      return guess, guessed_letters
    else
      puts "Invalid guess--the guess must be a single letter and not a previous letter->#{guessed_letters}."
    end
  end
end

def check_guess(word, letter, blanks, incorrect_guesses)
  if word.include?(letter)
    word.each_char.with_index do |word_letter, index|
      if word_letter == letter
        blanks[index] = letter
      end
    end
  else  
    incorrect_guesses += 1
  end
  return blanks, incorrect_guesses
end

def win?(blanks)
  blanks.include?("_").!
end


def play_game(words)
  guessed_letters = ""
  incorrect_guesses = 0
  current_word = select_game_word(words)
  blanks = create_blanks_of_word(current_word)
  guessed_letters = ""
  while incorrect_guesses <= INCORRCET_GUESS_MAX
    puts("#{incorrect_guesses} of #{INCORRCET_GUESS_MAX} wrong guesses.")
    print_blanks(blanks)
    letter_guess, guessed_letters = get_guess(guessed_letters)
    blanks, incorrect_guesses = check_guess(current_word, letter_guess, blanks, incorrect_guesses)
    if win?(blanks)
      puts("You won with #{incorrect_guesses} wrong guesses! The word was #{current_word}.")
      return
    end
  end
  puts "You lost. The word was #{current_word}"
end

play_game(words)
