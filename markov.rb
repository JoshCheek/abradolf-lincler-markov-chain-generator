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

# http://www.abrahamlincolnonline.org/
# http://www.hitler.org/writings/Mein_Kampf/
ARGV.each do |file|
  tokens = File.read(file).split(/\s+|(?<!-)\b(?!-)/).map(&:downcase)
  start_words << tokens.take(2)
  tokens.each_cons 3 do |pre1, pre2, post|
    chain[[pre1, pre2]] << post
    start_words << [pre2, post] if end_of_sentence? pre1
  end
end


sentence = []
word1, word2 = start_words.sample
while word1
  sentence << word1
  break sentence << word2 if end_of_sentence? word2
  word1, word2 = word2, chain[[word1, word2]].sample
end
puts join_sentence sentence
