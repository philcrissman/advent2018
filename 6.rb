require 'pry'

@input = File.read("./input6.txt").split("\n").map{|n| n.split(",").map{|k| k.to_i}}

max = @input.flatten.max + 1

@space = (0..max).map{ (0..max).map{'.'}}

@locations = ("A".."AX").to_a

@location_map = @input.zip(@locations).to_h

@location_map.keys.each do |x,y|
  @space[y][x] = @location_map[[x,y]]
end

def manhattan_distance(x,y,x1,y1)
  [x,x1].sort.reverse.inject(:-) + [y,y1].sort.reverse.inject(:-)
end

(0..max).each do |y|
  (0..max).each do |x|
    next if @input.include?([x,y]) # skip if this is one of the actual locations
    @dm = {}
    @input.each do |c|
      d = manhattan_distance(x,y,c[0],c[1])
      @dm[d] ||= []
      @dm[d] << c
    end
    shortest = @dm.min_by{|k,v| k}
    #puts "shortest= #{shortest}"
    next if shortest[1].count > 1
    @space[y][x] = @location_map[shortest[1][0]].downcase
  end
end

edges = (@space.first + @space.last + @space.map(&:first) + @space.map(&:last)).flatten.uniq

@accum = Hash.new(0)

@space.flatten.each{|n| next if (edges.include?(n)); @accum[n.downcase] += 1}

puts @accum.max_by{|k,v| v}

def space_map
  @space.map{|x| x.join}.join("\n")
end

#---
#
# Part 2


@space2 = (0..max).map{ (0..max).map{'.'}}

(0..max).each do |y|
  (0..max).each do |x|
    #next if @input.include?([x,y]) # skip if this is one of the actual locations
    @dm = []
    @input.each do |c|
      d = manhattan_distance(x,y,c[0],c[1])
      @dm << d
    end
    @space2[y][x] = @dm.inject(:+)
  end
end

puts "Part 2 : #{@space2.flatten.select{|el| el if el < 10000}.count}"
