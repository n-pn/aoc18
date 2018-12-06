def distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

min_x = 9999
max_x = -9999
min_y = 9999
max_y = -9999

input = File.readlines('./input').map do |line|
  x, y = line.match(/(\d+), (\d+)/).captures.map(&:to_i)

  min_x = x if x < min_x
  max_x = x if x > max_x
  min_y = y if x < min_y
  max_y = y if x > max_y

  [x, y]
end

count = 0

avg = 10000 / input.size

((min_x - avg - 1)..(max_x + avg + 1)).each do |i|
  ((min_y - avg - 1)..(max_y + avg + 1)).each do |j|
    total =  input.map{|d| distance([i,j], d)}.sum
    count += 1 if total < 10000
  end
end

puts count
