@power = Array.new(300) {Array.new(300)}

@input = 9306

(1..300).each do |i|
  rack = i + 10
  (1..300).each do |j|
    power = (rack * j + @input) * rack % 1000 / 100 - 5
    @power[i - 1][j - 1] = power
    @power[i - 1][j - 1] += @power[i - 1][j - 2] if j > 1
  end
end

def get_sum(x, i, j)
  return @power[x - 1][j - 1] if i < 2
  @power[x - 1][j - 1] - @power[x - 1][i - 2]
end

max_sum = 0
max_x = 0
max_y = 0
max_n = 0

(1..300).each do |i|
  (1..300).each do |j|
    m = 300 - i
    m = 300 - j if m > 300 - j

    (0..m).each do |n|
      sum = 0

      n.times do |x|
        sum += get_sum(i + x, j, j + n - 1)
      end

      if sum > max_sum
        max_sum = sum
        max_x = i
        max_y = j
        max_n = n
      end
    end
  end
end

puts [max_x, max_y, max_n, max_sum].to_s
