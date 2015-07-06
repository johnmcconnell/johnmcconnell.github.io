#!/usr/bin/env ruby
require 'pp'

TAGS = [0, 1, 2]
CHARACTERS = [:a, :b, :c, :d]

word_probs = Hash.new { |h,k| h[k] = {} }
raw_word_probs = [[0.6, 0.1, 0.2, 0.1], [0.3, 0.4, 0.1, 0.2], [0.1, 0.2, 0.3, 0.4]]
raw_word_probs.each_with_index do |character_probs, tag|
  character_probs.zip(CHARACTERS).each do |prob, character|
    word_probs[tag][character] = prob
  end
end

WORD_PROBS = word_probs.freeze

tag_probs = Hash.new { |h,k| h[k] = {} }
raw_tag_probs = [[0.5, 0.3, 0.2], [0.2, 0.4, 0.4], [0.3, 0.5, 0.2]]
raw_tag_probs.each_with_index do |t_probs, tag1|
  t_probs.each_with_index do |prob, tag2|
    tag_probs[tag1][tag2] = prob
  end
end

TAG_PROBS = tag_probs.freeze

trellis = Hash.new { |h,k| h[k] = {} }

trellis[0][:empty] = 0.33
trellis[1][:empty] = 0.33
trellis[2][:empty] = 0.34

trellis[0][:a] = 0.198
trellis[1][:a] = 0.099
trellis[2][:a] = 0.033

def next_column(previous_word, word, trellis)
  TAGS.map do |tag|
    TAGS.map do |previous_tag|
      prob = trellis[previous_tag][previous_word] * WORD_PROBS[tag][word] * TAG_PROBS[previous_tag][tag]
      {prob: prob, previous_tag: previous_tag, tag: tag}
    end.max_by {|e| e[:prob] }
  end
end

def update_trellis(trellis, col, word)
  col.each do |result|
    tag = result.fetch(:tag)
    prob = result.fetch(:prob)
    trellis[tag][word] = prob
  end
end

sentence = ARGV.map(&:to_sym)

l = sentence.size
bigrams = sentence[0, l-1].zip(sentence[1, l])
puts "Bigram\r\n"
pp bigrams

puts "Trellis\r\n"
pp trellis

bigrams.each do |(previous_word, word)|
  puts "Next Column\r\n"
  col = next_column(previous_word, word, trellis)
  pp col
  puts
  update_trellis(trellis, col, word)
  puts "Next Trellis\r\n"
  pp trellis
  puts
end
