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
    @guesses = []
    @remaining_guesses = 7
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

    return if @guesses.include? guess

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
