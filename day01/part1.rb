def change(arr)
  arr.map(&:to_i).sum
end

puts change(["+1", "+1", "+1"])
puts change(["+1", "+1", "-2"])
puts change(["-1", "-2", "-3"])

puts change(File.readlines('./input'))
