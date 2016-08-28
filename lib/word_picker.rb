def pick_word
  File.read('/usr/share/dict/words').split.sample
end
