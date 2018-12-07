require 'set'

deps = Hash.new{|h, k| h[k] = Set.new}

File.readlines('./input').each do |line|
  a, b = line.match(/^Step (\w) must be finished before step (\w) can begin.$/).captures
  deps[b].add(a)
end

done = []

while true
  break unless char = ('A'..'Z').find{|c| deps[c].size == 0 and !done.include?(c)}
  ('A'..'Z').each{ |c| deps[c].delete(char) }
  done << char
end

puts done.join
