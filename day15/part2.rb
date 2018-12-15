class Solve
  Pos = Struct.new(:x, :y)
  Npc = Struct.new(:race, :id, :hp, :pos)

  UNREACH = 1000000

  attr_reader :elves, :winner, :outcome

  def initialize(input, power)
    @map = input.map{|x| x.strip.split('')}
    @power = power

    @m = @map.size
    @n = @map.first.size

    @elves = {}
    @gobls = {}

    @m.times do |i|
      @n.times do |j|
        c = @map[i][j]
        @elves[@elves.size] = Npc.new(c, @elves.size, 200, Pos.new(i, j)) if c == 'E'
        @gobls[@gobls.size] = Npc.new(c, @gobls.size, 200, Pos.new(i, j)) if c == 'G'
      end
    end

    @elves_count = @elves.size
    @turn = 0
  end

  def get_distances(npc)
    res = Array.new(@m){Array.new(@n, UNREACH)}

    res[npc.pos.x][npc.pos.y] = 0
    queue = [npc.pos]

    time = 0
    while !queue.empty?
      time += 1
      new_queue = []

      queue.each do |pos|
        [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |a, b|
          if @map[pos.x + a][pos.y + b] == '.' and res[pos.x + a][pos.y + b] == UNREACH
            new_queue << Pos.new(pos.x + a, pos.y + b)
            res[pos.x + a][pos.y + b] = time
          end
        end
      end
      queue = new_queue
    end

    res
  end

  def reachable_places(enemies)
    reaches = []

    enemies.values.each do |npc|
      reaches << Pos.new(npc.pos.x - 1, npc.pos.y) if @map[npc.pos.x - 1][npc.pos.y] == '.'
      reaches << Pos.new(npc.pos.x + 1, npc.pos.y) if @map[npc.pos.x + 1][npc.pos.y] == '.'
      reaches << Pos.new(npc.pos.x, npc.pos.y - 1) if @map[npc.pos.x][npc.pos.y - 1] == '.'
      reaches << Pos.new(npc.pos.x, npc.pos.y + 1) if @map[npc.pos.x][npc.pos.y + 1] == '.'
    end

    reaches
  end

  def trace_back(distances, pos)
    x = pos.x
    y = pos.y
    traces = [pos]

    dis = distances[x][y] - 1

    while dis > 0
      if distances[x - 1][y] == dis then x -= 1
      elsif distances[x][y -1] == dis then y -= 1
      elsif distances[x][y + 1] == dis then y += 1
      elsif distances[x + 1][y] == dis then x += 1
      end

      dis -= 1
      traces << Pos.new(x, y)
    end

    traces
  end

  @turn = 0

  def races_of(npc)
    npc.race == 'E' ? @elves : @gobls
  end

  def enemies_of(npc)
    npc.race == 'G' ? @elves : @gobls
  end

  def attack(npc, enemies)
    nearby = enemies.values.select{|e| (e.pos.x - npc.pos.x).abs + (e.pos.y - npc.pos.y).abs == 1}
    return false if nearby.empty?

    target = nearby.sort_by{|e| [e.hp, e.pos.x, e.pos.y]}.first
    target.hp -= npc.race == 'G' ? 3 : @power

    if target.hp < 1
      enemies.delete(target.id)
      @map[target.pos.x][target.pos.y] = '.'
    end

    true
  end

  def move(npc)
    return if npc.hp <= 0
    enemies = enemies_of(npc)

    if enemies.empty?
      # puts @turn
      @outcome = @turn * (@elves.values + @gobls.values).map{|x| x.hp}.sum
      # @outcome = @turn * races_of(npc).values.map{|x| x.hp}.sum
      @winner = npc.race == 'G' ? 'Goblins' : 'Elves'
      @halt = true
      return
    end

    return if attack(npc, enemies)

    reaches = reachable_places(enemies)
    return "UNREACHABLE" if reaches.empty?

    distances = get_distances(npc)
    reach_distances = []

    reaches.each do |pos|
      dis = distances[pos.x][pos.y]
      reach_distances << [pos, dis] if dis != UNREACH
    end

    return if reach_distances.empty?

    reach = reach_distances.sort_by {|pos, dis| [dis, pos.x, pos.y]}.first[0]
    trace = trace_back(distances, reach)
    pos = trace.last

    @map[npc.pos.x][npc.pos.y] = '.'
    @map[pos.x][pos.y] = npc.race

    npc.pos.x = pos.x
    npc.pos.y = pos.y

    attack(npc, enemies)
  end

  def run
    @halt = false

    loop do
      (@elves.values + @gobls.values)
        .sort_by{|npc| [npc.pos.x, npc.pos.y]}
        .each do |npc|
          move(npc)
          return if @halt
        end
      @turn += 1
    end
  end

  def all_elves_alive?
    @elves.size == @elves_count
  end

end

input = File.readlines('./input')
power = 3

loop do
  solver = Solve.new(input, power)
  solver.run

  if solver.all_elves_alive?
    puts power
    puts solver.elves.to_s
    # puts solver.elves.count
    puts solver.outcome
    break
  end

  power += 1
end
