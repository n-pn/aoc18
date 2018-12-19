t = 10551376
r = 0
i = 1

while i <= t
  r += i if t % i == 0
  i += 1
end

puts r
