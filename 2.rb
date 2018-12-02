@input = File.read("./input2.txt")

strings = @input.split("\n")

counts = strings.map do |string|
  arr = string.split ''
  arr.group_by{|c| arr.select{|k| k == c}.count}
end

twos = counts.select{|element| element.keys.include?(2)}.count
threes = counts.select{|element| element.keys.include?(3)}.count

checksum = twos * threes

puts "Part 1: #{checksum}"

total = strings.count

(0..25).each do |i|
  if strings.map do |str|
    if i == 0
      str[1..25]
    elsif i == 25
      str[0..24]
    else
      str[0..i-1] + str[i+1..25]
    end
  end.uniq.count < total;
    puts "Part 2: it's index #{i}"
  end
end

has_dup = strings.map{|str| str[0..19] + str[21..25]}
count = has_dup.group_by{|e| has_dup.select{|k| k == e}.count}
puts count[2][0]

