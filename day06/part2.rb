input = File.readlines('./input').map do |line|
  x, y = line.match(/(\d+), (\d+)/).captures.map(&:to_i)
end

min_x = 9999
max_x = 0
min_y = 9999
max_y = 0

input.each do |x, y|
  min_x = x if x < min_x
  max_x = x if x > max_x
  min_y = y if x < min_y
  max_y = y if x > max_y
end

def distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

# map = Hash.new{|h, k| h[k] = Hash.new(input.size)}

count = 0

avg = 10000 / input.size

((min_x - avg - 1)..(max_x + avg + 1)).each do |i|
  ((min_y - avg - 1)..(max_y + avg + 1)).each do |j|
    total =  input.map{|d| distance([i,j], d)}.sum
    count += 1 if total < 10000
  end
end

puts count

# count = Hash.new(0)
# edges = Hash.new(false)

# (min_x..max_x).each do |i|
#   (min_y..max_y).each do |j|
#     count[map[i][j]] += 1

#     if (i == min_x or i == max_x or j == min_y or j == max_y)
#       edges[map[i][j]] = true
#     end
#   end
# end

# count = count.reject{|k, v| edges[k]}.sort_by{|x, y| y}

# puts count.last.last
