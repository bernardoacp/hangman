require_relative "game"

print "Hangman initialized!\n\n"

puts "Do you yant to (1) start a new game or (2) load last saved game?"
option = gets.chomp.to_i

if option == 1
  Game.new.play
elsif option == 2
  string = File.read("game_save.yml")
  Game.from_yaml(string).play
else
  puts "Invalid input."
end
