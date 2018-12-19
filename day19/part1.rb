
def run(ins, reg)
  op, a, b, r = ins

  case op
  when 'addr' then reg[r] = reg[a] + reg[b]
  when 'addi' then reg[r] = reg[a] + b
  when 'mulr' then reg[r] = reg[a] * reg[b]
  when 'muli' then reg[r] = reg[a] * b
  when 'banr' then reg[r] = reg[a] & reg[b]
  when 'bani' then reg[r] = reg[a] & b
  when 'borr' then reg[r] = reg[a] | reg[b]
  when 'borr' then reg[r] = reg[a] | b
  when 'setr' then reg[r] = reg[a]
  when 'seti' then reg[r] = a
  when 'gtir' then reg[r] = a > reg[b] ? 1 : 0
  when 'gtri' then reg[r] = reg[a] > b ? 1 : 0
  when 'gtrr' then reg[r] = reg[a] > reg[b] ? 1 : 0
  when 'eqir' then reg[r] = a == reg[b] ? 1 : 0
  when 'eqri' then reg[r] = reg[a] == b ? 1 : 0
  when 'eqrr' then reg[r] = reg[a] == reg[b] ? 1 : 0
  end

  reg
end

# puts @ops.to_s
input = File.readlines('./input')
ip_key = input.shift.split(' ', 2).last.to_i

input = input.map do |line|
  ins = line.strip.split(' ')
  [ins.first] + ins[1..3].map(&:to_i)
end

ip_val = 0
reg = [0, 0, 0, 0, 0, 0]

require 'set'

vals = Set.new

while ip_val < input.size
  ins = input[ip_val]
  reg[ip_key] = ip_val

  # print "ip=#{ip_val} #{reg.to_s} #{ins.join(' ')} "
  reg = run(ins, reg)

  vals.add(reg[1])
  # puts reg.to_s

  ip_val = reg[ip_key] + 1
end

puts vals.to_s
# puts reg.to_s

# puts reg[0]
