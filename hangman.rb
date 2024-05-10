require "json"

# Load viable words into array.
contents = File.readlines("./google-10000-english-no-swears.txt")
words = []
contents.each do |word|
  if word.delete!("\n").length.between?(5, 12)
    words.append(word)
  end 
end

class Hangman
  INCORRCET_GUESS_MAX = 8
  def initialize()
    @guessed_letters = ""
    @game_word = ""
    @blanks = ""
    @incorrect_guesses = 0
  end

  def save_game
    data = {guessed_letters: @guessed_letters, game_word: @game_word, blanks: @blanks, incorrect_guesses: @incorrect_guesses}
    json_data = JSON.generate(data)
    File.open("saves.txt", "w") do |file|
      file.puts json_data
    end
  end

  def load_game
    File.open("saves.txt", "r") do |file|
      dict = JSON.parse(file.read)
      @guessed_letters = dict["guessed_letters"]
      @game_word = dict["game_word"]
      @blanks = dict["blanks"]
      @incorrect_guesses = dict["incorrect_guesses"]
    end
  end

  def select_game_word(words)
    @game_word = words.sample()
  end 

  def create_blanks_of_word()
    @blanks = ""
    @game_word.length.times do 
      @blanks += "_"
    end
  end

  def print_blanks()
    @blanks.each_char do |blank|
      print(blank + " ")
    end
    print("\n")
  end


  def get_input()
    puts "Enter your single letter guess. Enter 0 to save for later."
    while true
      guess = gets.chomp.downcase
      if guess.length == 1 && guess.match?(/[[:alpha:]]/) && @guessed_letters.include?(guess).!
        @guessed_letters += guess
        return guess
      elsif guess == "0"
        save_game()
        return guess
      else
        puts "Invalid guess--the guess must be a single letter and not a previous letter->#{@guessed_letters}."
      end
    end
  end

  def check_guess(letter)
    if @game_word.include?(letter)
      @game_word.each_char.with_index do |word_letter, index|
        if word_letter == letter
          @blanks[index] = letter
        end
      end
    else  
      @incorrect_guesses += 1
    end
    return 
  end

  def win?()
    @blanks.include?("_").!
  end

  def new_game?()
    while true
      puts "Do you want to a new game (n) or to load your last game (l)?"
      answer = gets.chomp.downcase
      if answer == "n"
        return true
      elsif answer == "l"
        return false
      end
    end
  end

  def play_game(words)
    if new_game?()
      @game_word = select_game_word(words)
      create_blanks_of_word()
    else
      load_game()
    end
    while @incorrect_guesses <= INCORRCET_GUESS_MAX
      puts("#{@incorrect_guesses} of #{INCORRCET_GUESS_MAX} wrong guesses.")
      print_blanks()
      letter_guess = get_input()
      if letter_guess == "0"
        return
      end
      check_guess(letter_guess)
      if win?()
        puts("You won with #{@incorrect_guesses} wrong guesses! The word was #{@game_word}.")
        return
      end
    end
    puts "You lost. The word was #{@game_word}."
  end

end

game = Hangman.new()
game.play_game(words)
# game.load_game
