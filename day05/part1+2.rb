input = File.read('./input').strip
# input = 'dabAcCaCBAcCcaDA'

def match?(a, b)
  a != b && a.upcase == b.upcase
end

def reduce(s)
  s = s.chars
  rest = [s.first]
  curr = 1
  while curr < s.size
    char = s[curr]
    curr += 1
    if rest.size == 0 or !match?(rest.last, char)
      rest << char
    else
      rest.pop
    end
  end

  rest
end

puts reduce(input).size

res_count = input.size
res_char = nil

('a'..'z').each do |x|
  s = input.gsub(/#{x}/i, '')
  c = reduce(s).size
  if c < res_count
    res_count = c
    res_char = x
  end
end

puts res_char, res_count
