max = 7158800
len = 430
idx = 0
arr = Array.new(len, 0)

@prev = Array.new(max + 1)
@next = Array.new(max + 1)
@prev[0] = @next[0] = 0
@curr = 0

(1..max).each do |curr|
  idx = (idx + 1) % len

  if curr % 23 == 0
    7.times { @curr = @prev[@curr] }

    _next = @next[@curr]
    _prev = @prev[@curr]

    @prev[_next] = _prev
    @next[_prev] = _next

    arr[idx] += curr + @curr
    @curr = _next
  else
    _prev = @next[@curr]
    _next = @next[_prev]

    @next[_prev] = curr
    @prev[_next] = curr
    @prev[curr] = _prev
    @next[curr] = _next

    @curr = curr
  end
end

puts arr.max
