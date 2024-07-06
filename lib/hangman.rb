words = []

lines = File.readlines("google-10000-english-no-swears.txt")
lines.each do |line|
  word = line.chomp
  words << word if word.length >= 5 && word.length <= 12
end
