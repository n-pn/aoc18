@map = File.readlines('./input').map{|x| x.strip.split('')}

@m = @map.size
@n = @map.first.size

@npcs = []

@m.times do |i|
  @n.times do |j|
    if @map[i][j] == 'G' or @map[i][j] == 'E'
      @npcs << [@map[i][j], i, j, 200]
    end
  end
end

def print_map
  puts @map.map{|x| x.join('')}.join("\n")
  puts "\n"
end

def sort_list(arr)
  arr.sort_by{|_, x, y, _| [x, y]}
end

UNREACH = 1000000

def get_distances(npc)
  distances = Array.new(@m){Array.new(@n, UNREACH)}

  distances[npc[1]][npc[2]] = 0
  reaches = [[npc[1], npc[2]]]

  time = 0

  while reaches.size > 0
    time += 1
    x, y = reaches.pop

    if @map[x - 1][y] == '.' and distances[x - 1][y] == UNREACH
      reaches << [x - 1, y]
      distances[x - 1][y] = time
    end

    if @map[x + 1][y] == '.' and distances[x + 1][y] == UNREACH
      reaches << [x + 1, y]
      distances[x + 1][y] = time
    end

    if @map[x][y - 1] == '.' and distances[x][y - 1] == UNREACH
      reaches << [x, y - 1]
      distances[x][y - 1] = time
    end

    if @map[x][y + 1] == '.' and distances[x][y + 1] == UNREACH
      reaches << [x, y + 1]
      distances[x][y + 1] = time
    end
  end

  distances
end

def get_enemy_npcs(type)
  case type
  when 'G' then @npcs.select{|x| x[0] == 'E' and x[3] > 0}
  when 'E' then @npcs.select{|x| x[0] == 'G' and x[3] > 0}
  end
end

def reachable_places(enemies)
  reaches = []

  enemies.each do |_, x, y, _|

    reaches << [x - 1, y] if @map[x - 1][y] == '.'
    reaches << [x + 1, y] if @map[x + 1][y] == '.'
    reaches << [x, y - 1] if @map[x][y - 1] == '.'
    reaches << [x, y + 1] if @map[x][y + 1] == '.'
  end

  reaches
end

def trace_back(distances, x, y)
  traces = [[x, y]]
  dis = distances[x][y] - 1

  while dis > 0
    if distances[x - 1][y] == dis
      x -= 1
    elsif distances[x][y -1] == dis
      y -= 1
    elsif distances[x][y + 1] == dis
      y += 1
    elsif distances[x + 1][y] == dis
      x += 1
    end

    dis -= 1
    traces << [x, y]
  end

  traces
end

def move(npc)
  distances = get_distances(npc)
  # puts npc.to_s

  enemies = get_enemy_npcs(npc[0])

  return "NO ENEMY" if enemies.empty?

  reaches = reachable_places(enemies)
  reach_distances = []

  reaches.each do |x, y|
    if distances[x][y] != UNREACH
      reach_distances << [distances[x][y], x, y]
    end
  end

  return "UNREACHABLE" if reach_distances.empty?

  target = reach_distances.sort_by {|m, x, y| [m, x, y]}.first

  move = trace_back(distances, target[1], target[2]).last

  @map[npc[1]][npc[2]] = '.'
  @map[move[0]][move[1]] = npc[0]

  return "REACHABLE"
end

def is_enemy(a, b)
  a == 'G' && b == 'E' or a == 'E' && b == 'G'
end

def attack(npc)
  c, x, y
  enemies = []
end

print_map

turn = 1

@npcs.each do |npc|
  case move(npc)
  when "NO ENEMY"
    puts turn
    return
  when "REACHABLE"
    attack(npc)
  end
end

print_map

