Node = Struct.new(:prev, :next)

@ring = {}
@ring[0] = Node.new(0, 0)
@curr = 0

def insert(idx)
  _prev = @ring[@curr].next
  _next = @ring[_prev].next

  @ring[_prev].next = idx
  @ring[_next].prev = idx
  @ring[idx] = Node.new(_prev, _next)
  @curr = idx
end

def remove
  7.times { @curr = @ring[@curr].prev }

  _next = @ring[@curr].next
  _prev = @ring[@curr].prev

  @ring[_next].prev = _prev
  @ring[_prev].next = _next

  res = @curr
  @curr = _next

  res
end

m = 7158800
n = 430
i = 0
a = Array.new(n, 0)

m.times do |x|
  x += 1
  i = (i + 1) % n

  if x % 23 == 0
    a[i] += x + remove()
  else
    insert(x)
  end
end

puts a.max
