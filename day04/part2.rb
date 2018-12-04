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

minute = nil
guard = nil
count = 0

sleeps.each do |g, p|
  (0..59).each do |m|
    c = 0
    p.each do |a, b|
      c += 1if a <= m and m <= b
    end

    if c > count
      minute = m
      guard = g
      count = c
    end
  end
end

puts guard * minute
