lines = File.readlines('./input')

initial = lines[0].strip.sub('initial state: ', '')
@map = lines[2..-1].map{|line| line.strip.split(' => ', 2)}.to_h

def format(old_state, index)
  compact = old_state.sub(/\.+$/, '').sub(/^\.+/, '')
  new_state = '....' + compact + '....'

  old_index = old_state.index(compact)
  new_index = new_state.index(compact)

  [new_state, index + new_index - old_index]
end

def change(state, index)
  res = '..'
  (2...(state.size - 2)).each do |i|
    word = state[(i-2)..(i+2)]
    char = @map[word] || '.'
    res << char
  end

  format(res, index)
end

@states = {}
@state, @index = format(initial, 0)

@states[@state] = 0
count = 0

while true
  count += 1
  @state, @index = change(@state, @index)
  break if @states[@state]
  @states[@state] = count
end

loop_start = @states[@state]
loop_repeat = count

repeat = loop_repeat - loop_start

remain = 50000000000 - count
@index -= remain

sum = 0
@state.chars.each_with_index do |char, idx|
  sum += idx - @index if char == '#'
end

puts sum
