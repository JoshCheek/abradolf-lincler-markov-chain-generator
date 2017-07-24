def join_sentence(sentence)
  return '' if sentence.empty?
  joined = sentence[0].capitalize
  sentence.each_cons 2 do |pre, post|
    if post =~ /^[;\.,]$/
      joined << post
    else
      joined << " " << post
    end
  end
  joined
end

def end_of_sentence?(word)
  word == '.' || word == '!' || word == '?'
end

chain = Hash.new { |h, k| h[k] = [] }
start_words = []
matchers = []
while ARGV[0] =~ /--match=/
  ARGV.shift
  matchers << $'
end

# http://www.abrahamlincolnonline.org/
# http://www.hitler.org/writings/Mein_Kampf/
ARGV.each do |file|
  tokens = File.read(file).split(/\s+|(?<![-'])\b(?![-'])/).map(&:downcase)
  start_words << tokens.take(2)
  tokens.each_cons 3 do |pre1, pre2, post|
    chain[[pre1, pre2]] << post
    start_words << [pre2, post] if end_of_sentence? pre1
  end
end

loop do
  words = []
  word1, word2 = start_words.sample
  while word1
    words << word1
    break words << word2 if end_of_sentence? word2
    word1, word2 = word2, chain[[word1, word2]].sample
  end
  sentence = join_sentence words
  if matchers.all? { |m| sentence.downcase.include? m.downcase }
    puts sentence
    break
  end
end
