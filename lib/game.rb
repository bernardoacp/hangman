require "yaml"

class Game
  def initialize(new = true, word = nil, state = nil, guesses = nil, remaining_guesses = nil)

    if new == false
      @word = word
      @state = state
      @guesses = guesses
      @remaining_guesses = remaining_guesses
      return
    end

    words = []
    lines = File.readlines("google-10000-english-no-swears.txt")
    lines.each do |line|
      word = line.chomp
      words << word if word.length >= 5 && word.length <= 12
    end
    @word = words[Random.rand(words.length + 1)]
    @state = Array.new(@word.length, "_")
    @guesses = []
    @remaining_guesses = 7
  end

  def to_yaml
    YAML.dump ({
      word: @word,
      state: @state,
      guesses: @guesses,
      remaining_guesses: @remaining_guesses
    })
  end

  def self.from_yaml(string)
    data = YAML.load string
    self.new(false, data[:word], data[:state], data[:guesses], data[:remaining_guesses])
  end

  def play
    loop do
      if @remaining_guesses.zero?
        system "clear"
        display_state
        print "You ran out of guesses, game over!\n\n"
        print "The correct answer was: "
        @word.chars { |letter| print "#{letter} "}
        puts
        break
      elsif !@state.include? "_"
        system "clear"
        display_state
        puts "You won!"
        break
      end
      evaluate_guess
    end
  end

  private

  def display_state
    @state.each { |letter| print "#{letter} " }
    print "\n\n"
  end

  def display_guesses
    @guesses.each_with_index do |guess, idx|
      print "#{guess} - " unless idx == @guesses.length - 1
    end
    print "#{@guesses[@guesses.length - 1]}\n\n"
  end

  def prompt_guess
    system "clear"

    print "#{@temp}\n\n" unless @temp.nil?
    @temp = nil

    print "Enter \"save\" to save game and \"quit\" to quit\n\n"

    print "Remaining wrong guesses: #{@remaining_guesses}\n\n"
    unless @guesses.empty?
      puts "Guesses:"
      display_guesses
    end
    display_state
    print "Make your guess\n\n"
    gets.chomp.downcase
  end

  def evaluate_guess
    guess = prompt_guess

    if guess == "save"
      File.open("game_save.yml", "w") { |f| f.write to_yaml }
      @temp = "Game saved."
      return
    end

    exit if guess == "quit"

    if (@guesses.include? guess) || (guess.length != 1) || !guess.match?(/[A-Za-z]/)
      @temp = "Invalid guess."
      return
    end

    if @word.include? guess
      @word.length.times do |idx|
        @state[idx] = @word[idx] if @word[idx] == guess
      end
    else
      @remaining_guesses -= 1
    end
    @guesses << guess
  end
end
