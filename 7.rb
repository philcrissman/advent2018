require 'set'
input = File.read("./input7.txt").split("\n")

#str = <<-EOS
#Step C must be finished before step A can begin.
#Step C must be finished before step F can begin.
#Step A must be finished before step B can begin.
#Step A must be finished before step D can begin.
#Step B must be finished before step E can begin.
#Step D must be finished before step E can begin.
#Step F must be finished before step E can begin.
#EOS
#input = str.split "\n"

def parse line
  line.match(/^Step (\w) must be finished before step (\w)/).captures
end

@raw_orders = input.map{|line| parse(line)}

class Worker
  attr_reader :current_task

  def initialize
    @current_task = {}
  end

  def start_task(node, time_in_s)
    @current_task = {:task => node, :started => time_in_s}
  end

  require 'pry'
  def busy?(now)
    return false if @current_task.empty?
    binding.pry if @current_task[:task].nil?
    (now - @current_task[:started]) < @current_task[:task].task_time
  end

  def available?(now)
    !busy?(now)
  end
end

class Node
  @@nodes = []

  def self.create(value, points_to=nil, from = nil)
    unless node = find(value)
      node = Node.send(:new, value)
    end
    node.from(from) if from
    node.add(points_to) if points_to
    return node
  end

  def self.roots
    (nodes.map(&:value) - nodes.map(&:nodes).flatten.map(&:value).uniq).sort.map{|el| Node.find(el)}
  end

  def self.walk_tree(to_walk = roots, walked = [])
    return '' if to_walk.empty?
    i = 0
    while (true) do
      if to_walk[i].prereqs.all?{|n| walked.include?(n)}
      #if to_walk[i].prereqs.any?{|n| to_walk[i+1..-1].include?(n)}
        this = to_walk[i]
        walked << this
        break
      else
        i += 1
      end
    end
    
    remaining = (to_walk - [this] + this.nodes.to_a).uniq.sort_by(&:value)
    this.value + walk_tree(remaining, walked)
  end

  # need to initialize with workers
  def self.walk_with_workers(workers = [], to_walk = roots, walked = [], now = 0)
    return now if to_walk.empty? && workers.all?{|w| w.available?(now)}
    i = 0
    workers.each do |worker|
      next if worker.busy?(now)
      break if to_walk.empty?
    
      if !worker.current_task.empty?
        walked << worker.current_task[:task]
        to_walk = (to_walk + worker.current_task[:task].nodes.to_a).uniq.sort_by(&:value)
      end
      to_walk.each do |task|
        if task.prereqs.all?{|n| walked.include?(n)}
          this = to_walk.delete(task)
          worker.start_task(this, now)
        end
      end
    end

    walk_with_workers(workers, to_walk, walked, now + 1)
  end

  def self.find(value)
    @@nodes.select{|node| node.value == value}.first
  end

  def self.nodes
    @@nodes
  end

  attr_accessor :value

  private_class_method :new

  def initialize(value)
    @value = value
    @nodes = Set[]
    @from = Set[]
    @@nodes << self
  end

  def add(points_to)
    @nodes << Node.create(points_to, nil, self)
  end

  def task_time
    60 + ('A'..'Z').to_a.index(value) + 1
  end

  def from(from)
    @from << from
  end

  def prereqs
    @from.sort_by(&:value)
  end

  def nodes
    @nodes.sort_by(&:value)
  end
end

@nodes = @raw_orders.each do |pair|
  Node.create(*pair)
end

puts Node.walk_tree

workers = (1..5).map{ Worker.new }
puts Node.walk_with_workers(workers)
