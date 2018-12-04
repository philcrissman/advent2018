@input = File.read("./input4.txt").split("\n").sort

class GuardShift
  attr_reader :guard_id, :minutes, :date

  def initialize(date, guard_id)
    @date = date
    @guard_id = guard_id
    @minutes = Array.new(60, ".")
  end

  def sleeping!(falls_asleep, wakes_up)
    @minutes[falls_asleep..wakes_up-1] = (1..wakes_up-falls_asleep).map{"#"}
  end

  def minutes_asleep_count
    @minutes.select{|m| m == "#"}.count
  end

  def minutes_asleep
    @minutes.each_with_index.map{|m, i| i if m == "#"}.compact
  end
end

@guard_shifts = []

# Guard change logs
# .match(/\[\d{4}-(?<date>\d{2}-\d{2})\s.*\]\sGuard\s\#(?<guard_id>\d{1,6})?/)
# sleep/wake logs
# .match(/\[\d{4}-\d{2}-\d{2}\s\d{2}\:(?<minute>\d{2})\]\s(?<action>.+)/)
guard_shift_log = /\[\d{4}-(?<date>\d{2}-\d{2})\s.*\]\sGuard\s\#(?<guard_id>\d{1,6})?/
guard_sleep_log = /\[\d{4}-\d{2}-\d{2}\s\d{2}\:(?<minute>\d{2})\]\s(?<action>.+)/

@input.each_with_index do |line, index|
  # if it's a GuardChange, start a new GuardShift
  guard_shift = line.match(guard_shift_log)
  next if guard_shift.nil?
  shift = GuardShift.new(*guard_shift.captures)
  # other wise, we need 2 records to count sleep
  (index+1).step(index+100,2) do |i|
    break if @input[i].nil?
    break if @input[i].match(guard_shift_log)
    asleep = @input[i].match(guard_sleep_log)
    awake = @input[i+1].match(guard_sleep_log)
    raise 'wtf' if asleep.captures[1] != "falls asleep" and awake.captures[1] != "wakes up"
    shift.sleeping!(asleep.captures[0].to_i, awake.captures[0].to_i)
  end
  @guard_shifts << shift
end

@guards = @guard_shifts.group_by{|shift| shift.guard_id}
sleeps = {}
@guards.map{|k,v| sleeps[k] = v.map(&:minutes_asleep_count).inject(:+)}

guard_id = sleeps.sort_by{|k,v| v}.reverse[0][0]

sleeping_minutes = @guards[guard_id].map(&:minutes_asleep).flatten
@minutes = sleeping_minutes.group_by{|m| sleeping_minutes.select{|k| k == m}.count}
minute = @minutes.sort_by{|k,v| k}.reverse[0][1].uniq.first

puts "Part 1: #{guard_id.to_i*minute}"

@guards_sleeps_minutes = {}

@guards.map do |k,v|
  minutes = v.map(&:minutes_asleep).flatten
  sorted_minutes = minutes.group_by{|m| minutes.select{|k| k == m}.count}.sort_by{|k,v| k}.reverse
  next if sorted_minutes[0].nil?
  @guards_sleeps_minutes[k] = sorted_minutes[0]
end

huckleberry = @guards_sleeps_minutes.sort_by{|k,v| v}.reverse.first
puts "Part 2: #{huckleberry[0].to_i * huckleberry[1][1][0]}"
