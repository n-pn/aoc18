@input = File.read('./input').split(' ').map(&:to_i)

@kids = Hash.new{|h, k| h[k] = []}
@metas = Hash.new{|h, k| h[k] = []}

queue = [[0, @input[0], @input[1]]]
kid = 1
idx = 2

while q = queue.pop
  k, c, m = q
  if c == 0
    m.times do
      @metas[k] << @input[idx]
      idx += 1
    end
  else
    queue.push([k, c - 1, m])

    @kids[k] << kid
    queue.push([kid, @input[idx], @input[idx + 1]])

    kid += 1
    idx += 2
  end
end

def value(kid)
  return @metas[kid].sum if @kids[kid] == []
  @metas[kid].map{|m| m > @kids[kid].size ? 0 : value(@kids[kid][m - 1])}.sum
end

puts @metas.values.flatten.sum
puts value(0)
