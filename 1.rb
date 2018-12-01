input = File.read("./input.txt")

numbers = input.split("\n").map(&:to_i)

# part 1

sum = numbers.inject(:+) 

puts "Part 1: #{sum}"

# part 2

found = false
freqs = Hash.new(0)
nxt = 0
part2 = nil

while (!found) do
  nxt = numbers.inject(nxt) do |sum, n| 
    current = sum + n
    freqs[current] += 1
    if freqs[current] > 1
      found = true
      part2 = current
      puts "FOUND #{current}"
      break
    end
    current
  end
end

puts "Part 2: #{part2}"
