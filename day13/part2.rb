input = File.readlines('./input').map{|x| x.tr("\n","").split('')}

@m = input.size
@n = input.first.size
@track = Array.new(@m){Array.new(@n)}
@carts = []
@turns = Hash.new(0)

@m.times do |x|
  @n.times do |y|
    case c = input[x][y]
    when '<', '>'
      @carts << [@carts.size, x, y, c]
      @track[x][y] = '-'
    when '^', 'v'
      @carts << [@carts.size, x, y, c]
      @track[x][y] = '|'
    else
      @track[x][y] = c
    end
  end
end

def print_track
  puts @carts.to_s

  track = Array.new(@m){Array.new(@n)}

  @m.times do |x|
    @n.times do |y|
      track[x][y] = @track[x][y]
    end
  end


  @carts.each do |_, x, y, c|
    track[x][y] = c
  end

  puts track.map{|x| x.join}.join("\n")
end

def turn_left(cart)
  p, x, y, c = cart

  case c
  when '<' then [p, x + 1, y, 'v']
  when '^' then [p, x, y - 1, '<']
  when '>' then [p, x - 1, y, '^']
  when 'v' then [p, x, y + 1, '>']
  end
end

def turn_right(cart)
  p, x, y, c = cart

  case c
  when '<' then [p, x - 1, y, '^']
  when '^' then [p, x, y + 1, '>']
  when '>' then [p, x + 1, y, 'v']
  when 'v' then [p, x, y - 1, '<']
  end
end

def go_straight(cart)
  p, x, y, c = cart

  case c
  when '<' then [p, x, y - 1, c]
  when '^' then [p, x - 1, y, c]
  when '>' then [p, x, y + 1, c]
  when 'v' then [p, x + 1, y, c]
  end
end

def move_cart(cart)
  p, x, y, c = cart
  case tc = @track[x][y]
  when '+'
    @turns[p] += 1
    case @turns[p] % 3
    when 0 then turn_right(cart)
    when 1 then turn_left(cart)
    when 2 then go_straight(cart)
    end
  when '/'
    case c
    when '<' then turn_left(cart)
    when '^' then turn_right(cart)
    when '>' then turn_left(cart)
    when 'v' then turn_right(cart)
    end
  when '\\'
    case c
    when '<' then turn_right(cart)
    when '^' then turn_left(cart)
    when '>' then turn_right(cart)
    when 'v' then turn_left(cart)
    end
  else
    go_straight(cart)
  end
end

def pos(cart)
  cart[1] * @n + cart[2]
end

@takens = {}
@deleted = {}

@carts.each do |cart|
  @takens[pos(cart)] = cart[0]
end

while @deleted.size + 1 < @carts.size

  @carts.each_with_index do |cart, idx|
    next if @deleted[cart[0]]

    @takens.delete(pos(cart))
    cart = move_cart(cart)

    if x = @takens[pos(cart)]
      @takens.delete(pos(cart))
      @deleted[x] = true
      @deleted[cart[0]] = true
    else
      @takens[pos(cart)] = cart[0]
      @carts[idx] = cart
    end
  end

  @carts = @carts.sort_by{|_, x, y, _| [x, y]}
end

puts @carts.select{|x| !@deleted[x[0]]}.first.to_s
