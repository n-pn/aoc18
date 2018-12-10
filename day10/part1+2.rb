@input = File.readlines('./input').map do |line|
  line.match(/^[^-\d]+(-?\d+)[^-\d]+(\-?\d+)[^-\d]+(\-?\d+)[^-\d]+(\-?\d+)/).captures.map(&:to_i)
end

@input.map!{|px, py, vx, vy| [px + vx * 10000, py + vy * 10000, vx, vy]}
time = 10000

while true
  @input.map!{|px, py, vx, vy| [px + vx, py + vy, vx, vy]}
  time += 1

  min_x = min_y = 99999999
  max_x = max_y = -99999999

  @input.each do |px, py, _, _|
    min_x = px if min_x > px
    min_y = py if min_y > py
    max_x = px if max_x < px
    max_y = py if max_y < py
  end

  if (max_y - min_y) < 10
    map = Array.new(10){Array.new(62, '.')}
    @input.each{|px, py, _, _| map[py - min_y][px - min_x] = '#'}

    puts map.map{|x| x.join}.join("\n"), time
    break
  end
end




