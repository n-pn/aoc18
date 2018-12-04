re = /\[(\d+)-(\d\d)-(\d\d) (\d\d):(\d\d)\] (.+)/

input = File.readlines('./input').map do |line|
  line.strip.match(re).captures
end.sort

guard = nil
timer = 0

sleeps = Hash.new{|h, k| h[k] = Array.new}

input.each do |_, _, _, _, minute, event|
  minute = minute.to_i

  if event.end_with?('begins shift')
    guard = event.gsub(/\D/, '').to_i
    timer = 0
  elsif event == 'falls asleep'
    timer = minute
  else
    sleeps[guard] << [timer, minute - 1]
  end
end

guard = 0
duration = 0

sleeps.each do |g, p|
  d = p.map{|a, b| b - a}.sum
  if d > duration
    duration = d
    guard = g
  end
end

counts = Array.new(60, 0)

sleeps[guard].each do |a, b|
  (a..b).each do |i|
    counts[i] += 1
  end
end

puts counts.each_with_index.max[1] * guard
