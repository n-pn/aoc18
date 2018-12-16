input = File.read('./input').split("\n\n\n\n", 2).first

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

res = 0
samples.each do |sample|
  count = 0
  16.times do |i|
    count += 1 if run(i, sample.data, sample.before) == sample.after
  end
  res += 1 if count > 2
end

puts res
