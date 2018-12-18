input = File.readlines('./input').map{|x| x.sub("\n", '').split('')}

@m = input.size
@n = input.first.size

def is_type(map, x, y, type)
  return false if x < 0 or x >= @m
  return false if y < 0 or y >= @n
  map[x][y] == type
end

@ary = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def count_near(map, x, y, type)
  @ary.count{|i, j| is_type(map, x + i, y + j, type)}
end

def still_has_tree(map)
  @m.times{|i| @n.times{|j| return true if map[i][j] == '|'}}
  false
end

def change(map)
  out = Array.new(@m){Array.new(@n)}

  @m.times do |i|
    @n.times do |j|
      out[i][j] =
        case c = map[i][j]
        when '.' then count_near(map, i, j, '|') > 2 ? '|' : c
        when '|' then count_near(map, i, j, '#') > 2 ? '#' : c
        when '#' then count_near(map, i, j, '#') > 0 && count_near(map, i, j, '|') > 0 ? c : '.'
        end
    end
  end

  out
end

def run(input)
  states = {}
  i = 0

  loop do
    i += 1
    output = change(input)

    if x = states[output]
      return [output, i, x]
    end

    input = output
    states[input] = i
  end

  raise 'Wrong agruments!'
end

input, start, stop = run(input)

remain = (1000000000 - stop) % (stop - start)
remain.times{ input = change(input) }

tree = input.map{|x| x.count{|c| c == '|'}}.sum
lumb = input.map{|x| x.count{|c| c == '#'}}.sum
puts tree * lumb
