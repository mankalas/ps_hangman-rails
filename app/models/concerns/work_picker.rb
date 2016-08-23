module WordPicker
  UNIX_WORDS_PATH = '/usr/share/dict/words'
  def pick
    File.read(UNIX_WORDS_PATH).split.sample
  end
end
