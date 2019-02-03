input1, input2 = File.read('./input').split("\n\n\n\n", 2)

Sample = Struct.new(:before, :ins, :after)

samples = input1.split("\n\n").map do |samp|
  before, ins, after = samp.split("\n")

  before = before.match(/^Before: \[(\d+), (\d+), (\d+), (\d+)\]/).captures.map(&:to_i)
  ins = ins.split(' ').map(&:to_i)
  after = after.match(/^After:  \[(\d+), (\d+), (\d+), (\d+)\]/).captures.map(&:to_i)

  Sample.new(before, ins, after)
end

opcodes = input2.split("\n").map{|x| x.split(' ').map(&:to_i)}

def run(op, ins, reg)
  res = reg.dup
  _, a, b, r = ins

  res[r] =
    case op
    when 0 then reg[a] + reg[b]
    when 1 then reg[a] + b
    when 2 then reg[a] * reg[b]
    when 3 then reg[a] * b
    when 4 then reg[a] & reg[b]
    when 5 then reg[a] & b
    when 6 then reg[a] | reg[b]
    when 7 then reg[a] | b
    when 8 then reg[a]
    when 9 then a
    when 10 then a > reg[b] ? 1 : 0
    when 11 then reg[a] > b ? 1 : 0
    when 12 then reg[a] > reg[b] ? 1 : 0
    when 13 then a == reg[b] ? 1 : 0
    when 14 then reg[a] == b ? 1 : 0
    when 15 then reg[a] == reg[b] ? 1 : 0
    end

  res
end

require 'set'

res = 0
map = Hash.new{|h, k| h[k] = Set.new(0..15)}

samples.each do |samp|
  ops = (0..15).select {|i| run(i, samp.ins, samp.before) == samp.after}
  res += 1 if ops.size > 2
  map[samp.ins[0]] &= ops
end

puts "Part 1: #{res}"

out = {}

until map.empty?
  map = map.sort_by{|k, v| v.size}
  op, set = map.shift
  # raise 'Wrong arguments' if set.size != 1
  out[op] = set.first
  map.each{|k, v| v.delete(set.first)}
end

reg = opcodes.reduce([0, 0, 0, 0]){ |acc, ins| run(out[ins[0]], ins, acc) }

puts "Part 2: #{reg[0]}"
