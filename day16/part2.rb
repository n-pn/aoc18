input, opcodes = File.read('./input').split("\n\n\n\n", 2)

Sample = Struct.new(:before, :data, :after)

samples = input.split("\n\n").map do |sample|
  before, data, after = sample.split("\n")
  before = before.match(/^Before: \[(\d+), (\d+), (\d+), (\d+)\]/).captures.map(&:to_i)
  data = data.split(' ').map(&:to_i)
  after = after.match(/^After:  \[(\d+), (\d+), (\d+), (\d+)\]/).captures.map(&:to_i)

  Sample.new(before, data, after)
end

def run(op, ins, regs)
  _, a, b, r = ins
  res = regs.dup

  case op
  when 0 then res[r] = regs[a] + regs[b]
  when 1 then res[r] = regs[a] + b
  when 2 then res[r] = regs[a] * regs[b]
  when 3 then res[r] = regs[a] * b
  when 4 then res[r] = regs[a] & regs[b]
  when 5 then res[r] = regs[a] & b
  when 6 then res[r] = regs[a] | regs[b]
  when 7 then res[r] = regs[a] | b
  when 8 then res[r] = regs[a]
  when 9 then res[r] = a
  when 10 then res[r] = a > regs[b] ? 1 : 0
  when 11 then res[r] = regs[a] > b ? 1 : 0
  when 12 then res[r] = regs[a] > regs[b] ? 1 : 0
  when 13 then res[r] = a == regs[b] ? 1 : 0
  when 14 then res[r] = regs[a] == b ? 1 : 0
  when 15 then res[r] = regs[a] == regs[b] ? 1 : 0
  end

  res
end

# samples = [Sample.new([3,2,1,1], [9,2,1,2], [3,2,2,1])]

# ops = {}

# samples.each do |sample|
#   op = sample.data[0]
#   next if ops[op] && op[op].size == 1

#   posible = []

#   16.times do |i|
#     posible << i if run(i, sample.data, sample.before) == sample.after
#   end

#   if posible.size == 1
#     ops[sample.data[0]] = posible
#   else
#     if x = ops[op]
#       t = (x & posible)
#       ops[op] = t
#     else
#       ops[op] = posible
#     end
#   end
# end

# puts ops.sort_by{|k, v| v.size}.to_h.map{|k, v| "#{k} => #{v.join(" ")},"}.join("\n")

map = {
  12 => 0,
  9 => 1,
  3 => 2,
  6 => 3,
  1 => 4,
  5 => 5,
  11 => 6,
  2 => 7,
  8 => 8,
  4 => 9,
  10 => 10,
  14 => 11,
  7 => 12,
  15 => 13,
  0 => 14,
  13 => 15
}

regs = [0, 0, 0, 0]

opcodes = opcodes.split("\n").map{|x| x.split(' ').map(&:to_i)}

opcodes.each do |ins|
  regs = run(map[ins[0]], ins, regs)
end

puts regs[0]
