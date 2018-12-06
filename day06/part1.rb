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

map = Hash.new{|h, k| h[k] = Hash.new(input.size)}

(min_x..max_x).each do |i|
  (min_y..max_y).each do |j|
    distances = input.each_with_index.map{|d, t| [distance([i,j], d), t]}.sort_by{|d, t| d}

    if distances[0][0] != distances[1][0]
      map[i][j] = distances[0][1]
    end
  end
end

count = Hash.new(0)
edges = Hash.new(false)

(min_x..max_x).each do |i|
  (min_y..max_y).each do |j|
    count[map[i][j]] += 1

    if (i == min_x or i == max_x or j == min_y or j == max_y)
      edges[map[i][j]] = true
    end
  end
end

count = count.reject{|k, v| edges[k]}.sort_by{|x, y| y}

puts count.last.last
