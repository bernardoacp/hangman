class Game
  def initialize
    words = []
    lines = File.readlines("google-10000-english-no-swears.txt")
    lines.each do |line|
      word = line.chomp
      words << word if word.length >= 5 && word.length <= 12
    end
    @word = words[Random.rand(words.length + 1)]
    @state = Array.new(@word.length, "_")
    @guesses = 7
  end

  def play
    loop do
      if @guesses.zero?
        display_state
        puts "You ran out of guesses, game over!"
        break
      elsif !@state.include? "_"
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

  def prompt_guess
    print "Remaining wrong guesses: #{@guesses}\n\n"
    display_state
    print "Make your guess\n\n"
    gets.chomp.downcase
  end

  def evaluate_guess
    guess = prompt_guess
    if @word.include? guess
      @word.length.times do |idx|
        @state[idx] = @word[idx] if @word[idx] == guess
      end
    else
      @guesses -= 1
    end
  end
end
