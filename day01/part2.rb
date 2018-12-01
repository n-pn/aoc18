def reach(arr, freq = 0, hash = Hash.new(false))
  arr = arr.map(&:to_i)
  hash[freq] = true

  loop do
    arr.each do |i|
      freq += i
      return freq if hash[freq]
      hash[freq] = true
    end
  end
end

puts reach(["+1", "-1"])
puts reach(%w[+3 +3 +4 -2 -4])
puts reach(File.read('./input').split("\n"))
