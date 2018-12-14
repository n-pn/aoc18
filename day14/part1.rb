input = 793061

recipes = [3, 7]

i1 = 0
i2 = 1

while recipes.size < input + 10
  t = recipes[i1] + recipes[i2]
  if t > 9
    recipes << t / 10 << t % 10
  else
    recipes << t
  end

  i1 = (i1 + 1 + recipes[i1]) % recipes.size
  i2 = (i2 + 1 + recipes[i2]) % recipes.size
end

puts recipes[input, 10].join
