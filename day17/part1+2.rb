@spring_x = 500
@spring_y = 0

@min_x = @max_x = @spring_x
@min_y = 9999999999
@max_y = @spring_y

input = File.readlines('./input').map do |line|
  if line.start_with?('x=')
    x, y1, y2 = line.match(/x=(\d+), y=(\d+)..(\d+)/).captures.map(&:to_i)
    x1 = x2 = x
  else
    y, x1, x2 = line.match(/y=(\d+), x=(\d+)..(\d+)/).captures.map(&:to_i)
    y1 = y2 = y
  end

  @min_x = x1 if @min_x > x1
  @max_x = x2 if @max_x < x2
  @min_y = y1 if @min_y > y1
  @max_y = y2 if @max_y < y2
  [x1, x2, y1, y2]
end

@min_x -= 1
@max_x += 1

input = input.map{ |x1, x2, y1, y2| [x1 - @min_x, x2 - @min_x, y1, y2]}
@max_x -= @min_x
@spring_x -= @min_x
@min_x = 0

# puts input.to_s
# puts @max_x, @max_y

@map = Array.new(@max_y + 1){Array.new(@max_x + 1, '.')}

input.each do |x1, x2, y1, y2|
  (x1..x2).each do |x|
    (y1..y2).each do |y|
      @map[y][x] = '#'
    end
  end
end

@map[@spring_y][@spring_x] = '+'
@active = [[@spring_y, @spring_x]]

def is_floor(y, x)
  @map[y][x] == '#' or @map[y][x] == '~'
end

def is_brick(y, x)
  return false if x < 0 or x > @max_x
  @map[y][x] == '#'
end

until @active.empty?
  y, x = @active.pop
  # puts [y, x].to_s

  if y < @max_y
    if @map[y + 1][x] == '.'
      @active << [y, x] << [y + 1, x]
      @map[y + 1][x] = '|'
    elsif is_floor(y + 1, x)
      x1 = x2 = x

      while x1 - 1 > 0
        break unless is_floor(y + 1, x1 - 1)
        break if @map[y][x1 - 1] == '#'
        x1 -= 1
      end

      while x2 + 1 < @max_x
        break unless is_floor(y + 1, x2 + 1)
        break if @map[y][x2 + 1] == '#'
        x2 += 1
      end

      x1 -= 1 if  @map[y][x1 - 1] == '.'
      x2 += 1 if  @map[y][x2 + 1] == '.'

      if is_brick(y, x1 - 1) and is_brick(y, x2 + 1)
        (x1..x2).each{|i| @map[y][i] = '~'}
      else
        @active << [y, x1] if @map[y][x1 - 1] == '.'
        @active << [y, x2] if @map[y][x2 + 1] == '.'

        (x1..x2).each do |i|
          @map[y][i] = '|'

          if @map[y + 1][i] == '.'
            @map[y + 1][i] = '|'
            @active << [y + 1, i]
          end
        end
      end
    end
  end
end

# puts "\n", @map.map{|x| x.join}.join("\n"), "\n"
puts @map[@min_y..-1].map{|x| x.count{|c| c == '~' or c == '|'}}.sum
puts @map[@min_y..-1].map{|x| x.count{|c| c == '~'}}.sum


