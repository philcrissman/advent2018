input = File.read("./input5.txt")

@copy = input.dup.strip

@pairs = ('a'..'z').zip('A'..'Z').map{|n| n.join} + ('A'..'Z').zip('a'..'z').map{|n| n.join}

current_length = @copy.length

while(true) do
  @pairs.each do |pair|
    @copy = @copy.gsub(pair, '')
  end
  
  break if @copy.length == current_length
  current_length = @copy.length
end

puts "Part 1: #{@copy.strip.length}"

@new_copy = input.dup.strip
@results = {}

('a'..'z').each do |c|
  local = @new_copy.gsub(eval("/#{c}/i"),'')
  
  current_length = local.length

  while(true) do
    @pairs.each do |pair|
      local = local.gsub(pair, '')
    end
    
    break if local.length == current_length
    current_length = local.length
  end

  @results[c] = current_length
end

puts "Part 2 #{@results.min_by{|k,v| v}[1]}"
