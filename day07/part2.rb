FILE = './input'

require 'set'

deps = Hash.new{|h, k| h[k] = Set.new}
cost = ('A'..'Z').each_with_index.map{|c, i| [c, i + 61]}.to_h

File.readlines(FILE).each do |line|
  a, b = line.match(/Step (\w) must be finished before step (\w) can begin./).captures
  deps[b].add(a)
end

steps_taken = {}
worker_time = Array.new(5, 0)

time = 0

while time
  steps_taken.find_all{|c, t| t == time}.each do |c, _|
    ('A'..'Z').each{|char| deps[char].delete(c)}
  end

  chars = ('A'..'Z').reject{|c| steps_taken[c] or deps[c].size != 0}
  avail = worker_time.each_with_index.reject{|x, i| x > time }

  chars.each do |char|
    break unless w = avail.shift
    worker_time[w[1]] = steps_taken[char] = time + cost[char]
  end

  time = steps_taken.values.reject{|x| x <= time}.min
end

puts steps_taken.values.max
