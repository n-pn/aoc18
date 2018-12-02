
def differ(a, b)
  diff = 0
  same = ''
  a.size.times do |i|
    if a[i] == b[i]
      same << a[i]
    else
      diff += 1
    end
  end
  [diff, same]
end

s =  File.readlines('./input')
n = s.size - 1
a = []
0.upto(n).each do |i|
  (i+1).upto(n).each do |j|
    a << differ(s[i], s[j])
  end
end

puts a.sort_by{|x| x.first}.first.last
