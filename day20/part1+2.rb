

def marking(map, x, y, c)
  case c
  when 'N'
    map[x - 1][y] = '-'
    x -= 2
  when 'S'
    map[x + 1][y] = '-'
    x += 2
  when 'E'
    map[x][y + 1] = '|'
    y += 2
  when 'W'
    map[x][y - 1] = '|'
    y -= 2
  end

  [map, x, y]
end

def mapping(map, regex, x, y)
  return map if regex.empty?
  # puts regex.join

  i = 0

  while i < regex.size
    c = regex[i]
    break if c == '('
    map, x, y = marking(map, x, y, c)

    i += 1
  end

  return map if i == regex.size

  p = 1

  r = [[]]

  while p > 0
    i += 1
    c = regex[i]
    case c
    when '('
      p += 1
      r.last << c
    when ')'
      p -= 1
      r.last << c if p > 0
    when '|'
      if p == 1
        r << []
      else
        r.last << c
      end
    else r.last << c
    end
  end

  r.each {|t| map = mapping(map, t, x, y)}

  i += 1

  if i < regex.size
    map = mapping(map, regex[i..-1], x, y)
  end

  map
end

def painting(inp)
  map = Hash.new{|h,k| h[k] = Hash.new('#')}

  out = mapping(map, inp, 0, 0)

  min_x = max_x = min_y = max_y = 0

  map.each do |x, line|
    line.each do |y, c|
      if c == '|'
        min_x = x - 1 if min_x > x - 1
        max_x = x + 1 if max_x < x + 1
        min_y = y - 2 if min_y > y - 2
        max_y = y + 2 if max_y < y + 2
      else
        min_x = x - 2 if min_x > x - 2
        max_x = x + 2 if max_x < x + 2
        min_y = y - 1 if min_y > y - 1
        max_y = y + 1 if max_y < y + 1
      end
    end
  end

  max_x -= min_x
  max_y -= min_y

  pos_x = -min_x
  pos_y = -min_y

  res = Array.new(max_x + 1){Array.new(max_y + 1)}

  (0..max_x).each do |x|
    (0..max_y).each do |y|
      c = out[x + min_x][y + min_y]
      res[x][y] = if x % 2 == 1 then y % 2 == 1 ? '.' : c
                   else y % 2 == 1 ? c : '#' end
    end
  end

  res[pos_x][pos_y] = 'X'

  [res, pos_x, pos_y]
end

def movable?(map, x1, x2, y1, y2)
  return false if x2 < 0 or x2 >= map.size
  return false if y2 < 0 or y2 >= map.first.size
  return false if map[(x1 + x2) / 2][(y1 + y2) / 2] == '#'

  map[x2][y2] == '.'
end

def max_distance(map, x, y)
  dis = 0
  res = 0

  ary = [[x, y]]

  until ary.empty?
    nxt = []

    ary.each do |i, j|
      [[-2, 0], [2, 0], [0, -2], [0, 2]].each do |m, n|
        next unless movable?(map, i, i + m, j, j + n)
        map[i + m][j + n] = 'X'
        nxt << [i + m, j + n]
      end
    end

    ary = nxt

    dis += 1
    res += nxt.size if dis >= 1000
  end

  # puts map.map{|x| x.join}.join("\n")

  [dis - 1, res]
end

input = File.read('./input').strip.split('')[1..-2]

res, x, y = painting(input)
# res, x, y = painting('ENWWW(NEEE|SSE(EE|N))')
# res, x, y = painting('WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))'.split(''))

# puts res.map{|x| x.join}.join("\n"), "\n"

puts max_distance(res, x, y)
