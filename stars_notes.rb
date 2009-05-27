#!/usr/bin/ruby
require 'jcode'
$KCODE='UTF8'

players = Hash.new
out_header = ''
['notes.txt', 'notes2.txt'].each do |notes_file|
  in_header = ''
  File.open(notes_file) do |f|
    3.times { in_header << f.readline }

    begin
      while (l = f.readline)
        if l =~ /^\x00\x5B\x00\x70/u   # "[p" unicode
          player = l.scan(/\x00\x5b\x00\x70\x00\x6c\x00\x61\x00\x79\x00\x65\x00\x72\x00\x3d(.*)\x00\x5d\x00\x0d\x00\x0a/u)
        elsif l !~ /^\x00\x0d\x00\x0a$/
          note = l
          players.has_key?(player) ? players[player] << note : players[player] = note
        end
      end
    rescue EOFError
      f.close
      n = players[player]
      n[n.length-1] = ''
      players[player] = n
    end
  end
  out_header = in_header
end

File.open('notes.out', 'w+') do |f|
  f.print out_header
  players.each_pair do |player, notes|
    f.print "\x00\x5b\x00\x70\x00\x6c\x00\x61\x00\x79\x00\x65\x00\x72\x00\x3d"
    f.print player
    f.print "\x00\x5d\x00\x0d\x00\x0a"
    f.print notes
    f.print "\x00\x0d\x00\x0a"
    f.print "\x00\x0d\x00\x0a"
  end
  f.print "\x00"
end
    
    
  
