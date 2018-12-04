input = File.read("./input3.txt").split("\n")

# returns [id,left,top,x,y]
def parse(line)
  result = line.match(/\#(\d{1,4})\s\@\s(\d{1,4}),(\d{1,4})\:\s(\d{1,4})x(\d{1,4})$/)
  result.captures.map(&:to_i)
end

class Claim
  attr_reader :id, :left, :top, :x, :y

  def initialize(id, left, top, x, y)
    @id, @left, @top, @x, @y = id, left, top, x, y
  end
end

@claims = input.map{|line| Claim.new(*parse(line))}

@fabric = (1..1000).map{|n| (1..1000).map{[]}}

@claims.each do |claim|
  claim.y.times do |yindex|
    claim.x.times do |xindex|
      @fabric[claim.left+xindex][claim.top+yindex] << claim.id
    end
  end
end

count = @fabric.map{|row| row.select{|square| square.count > 1}.count}.inject(:+)
puts "Part 1: #{count}"

claim_ids = @fabric.map{|row| row.select{|square| square.count > 1}}.flatten.uniq
all_ids = (1..@claims.count).to_a

puts "Part 2: #{all_ids - claim_ids}"
