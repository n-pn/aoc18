require 'set'

def reach(arr, freq = 0, seen = Set.new)
  arr = arr.map(&:to_i)
  seen << freq

  arr.cycle do |i|
    freq += i
    return freq if seen.include?(freq)
    seen << freq
  end
end

puts reach(["+1", "-1"])
puts reach(%w[+3 +3 +4 -2 -4])
puts reach(File.readlines('./input'))
