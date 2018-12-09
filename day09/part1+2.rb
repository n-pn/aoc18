Node = Struct.new(:prev, :next)

max = 7158800
len = 430
idx = 0
arr = Array.new(len, 0)

@ring = Array.new(max + 1)
@ring[0] = Node.new(0, 0)
@curr = 0

(1..max).each do |curr|
  idx = (idx + 1) % len

  if curr % 23 == 0
    7.times { @curr = @ring[@curr].prev }

    _next = @ring[@curr].next
    _prev = @ring[@curr].prev

    @ring[_next].prev = _prev
    @ring[_prev].next = _next

    arr[idx] += curr + @curr
    @curr = _next
  else
    _prev = @ring[@curr].next
    _next = @ring[_prev].next

    @ring[_prev].next = curr
    @ring[_next].prev = curr
    @ring[curr] = Node.new(_prev, _next)
    @curr = curr
  end
end

puts arr.max
