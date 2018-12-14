input = [7, 9, 3, 0, 6, 1]

recipes = [3, 7]
matches = []

i1 = 0
i2 = 1

idx = 0

while true
  t = recipes[i1] + recipes[i2]
  new_matches = []

  if t > 9
    a = t / 10
    b = t % 10

    matches.each do |i|
      next if input[i] != a

      if i == input.size - 1
        puts recipes.size - i
        return
      end

      if input[i + 1] == b
        if i == input.size - 2
          puts recipes.size - i
          return
        end

        new_matches << i + 2
      end
    end

    new_matches << 2 if a == input[0] and b == input[1]
    new_matches << 1 if b == input[0]

    recipes << a << b
  else
    matches.each do |i|
      next if input[i] != t

      if i == input.size - 1
        puts recipes.size - i
        return
      else
        new_matches << i + 1
      end
    end

    new_matches << 1 if t == input[0]

    recipes << t
  end

  i1 = (i1 + 1 + recipes[i1]) % recipes.size
  i2 = (i2 + 1 + recipes[i2]) % recipes.size

  matches = new_matches
end

