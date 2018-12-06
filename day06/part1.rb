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

map = Array.new(max_x + 1){Array.new(max_y + 1, input.size)}

(min_x..max_x).each do |i|
  (min_y..max_y).each do |j|
    distances = input.each_with_index.map{|d, t| [distance([i,j], d), t]}.sort_by{|d, t| d}

    if distances[0][0] != distances[1][0]
      map[i][j] = distances[0][1]
    end
  end
end

count = Array.new(input.size + 1, 0)
edges = Array.new(input.size + 1, false)

(min_x..max_x).each do |i|
  (min_y..max_y).each do |j|
    count[map[i][j]] += 1

    if (i == min_x or i == max_x or j == min_y or j == max_y)
      edges[map[i][j]] = true
    end
  end
end

count = count.each_with_index.reject{|c, i| edges[i]}.sort_by{|c, i| -c}

puts count.first.first
