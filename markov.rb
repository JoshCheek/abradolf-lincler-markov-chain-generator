def join_sentence(sentence)
  return '' if sentence.empty?
  joined = sentence[0].capitalize
  sentence.each_cons 2 do |pre, post|
    if post =~ /^\W$/
      joined << post
    else
      joined << " " << post
    end
  end
  joined
end

chain = Hash.new { |h, k| h[k] = [] }
start_words = []

# http://www.abrahamlincolnonline.org/
# http://www.hitler.org/writings/Mein_Kampf/

ARGV.each do |file|
  tokens = File.read(file).split(/\s+|\b/).map(&:downcase)
  start_words << tokens[0].downcase
  tokens.each_cons 2 do |pre, post|
    chain[pre] << post
    start_words << post if pre == '.'
  end
end


sentence = []
crnt = start_words.sample
while crnt
  sentence << crnt
  break if crnt == '.'
  crnt = chain[crnt].sample
end
puts join_sentence sentence
