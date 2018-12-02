def count(a)
  c2 = c3 = 0

  a.each do |s|
    sc = Hash.new(0)
    s.chars.each{|c| sc[c] += 1}
    c2 += 1 if sc.values.include? 2
    c3 += 1 if sc.values.include? 3
  end

  c2 * c3
end

puts count(
  ['abcdef',
  'bababc',
  'abbcde',
  'abcccd',
  'aabcdd',
  'abcdee',
  'ababab'
])

puts count(File.readlines('./input'))
