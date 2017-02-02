
require 'pry'
class Node

  attr_accessor :parent, :word, :children
  attr_reader :value

  def initialize (value)
    @value = value
    @children = []
    @word = false
    @parent = parent
    @weight = 0
  end

end


class CompleteMe
  attr_reader :current_substring
  attr_accessor :root, :count, :weight_hash
  def initialize
    @root = Node.new('')
    @count = 0
    @weight_hash = Hash.new
    @current_substring = current_substring

  end

  def insert (word, parent_node = @root)
    first_letter = word[0]
    remaining = word[1..-1]
    found_node = false
    node = nil

# finds matching child node
    parent_node.children.each_with_index do |child_node, index|
       child_value_len = (child_node.value.length - 1) #?
      if first_letter == child_node.value[child_value_len]
        found_node = true
        node = parent_node.children[index]
      end
    end


      unless found_node
        node = Node.new(parent_node.value + first_letter)
        node.parent = parent_node
        parent_node.children << node
      end

      unless remaining.length.zero?
        self.insert(remaining, node)
      else
        @count += 1
        node.word = true
      end

  end

  def  insert_new_line_words (list)
    word_list = list.split("\n")
    word_list.each do |word|
      self.insert(word)
    end
  end
  def insert_words (words)
    words.each do |word|
      self.insert(word)

    end
  end
  def find_words (node, words = [])
    if node.word
      words << node.value
    end

    node.children.each do |child_node|
      self.find_words(child_node, words)

    end
    words
  end

  def suggest(substring, node = @root)
    @current_substring = substring
    @weight_hash[substring] = nil
    found_words = []
    if node.value == substring
      found_words =  find_words(node)
    else
      node.children.each do |child_node|
        found_words += self.suggest(substring, child_node)
      end
    end
    found_words
  end

  def selector (substring, selected_word, suggestions)
    @weight_hash[substring] = selected_word
    return nil



  end

  def get_user_input
    print "Please enter a substring for suggestions. >   "
    user_substring_input = gets.chomp
    user_suggestions = suggest(user_substring_input)
    initial_output = "Please choose one of the following words: "
    user_suggestions.each_with_index do |word, index|
      if index != (user_suggestions.length - 1)
        initial_output += "#{word}, "
      else
        initial_output += "#{word}."
      end
    end
    puts initial_output
    selection = gets.chomp
    selector(@current_substring, selection, user_suggestions)

  end

end

dictionary = File.open("/usr/share/dict/words", "r").read
test_trie = CompleteMe.new


#test_trie.insert_new_line_words(dictionary)
test_trie.insert_words(["hello", "sup", "hemp", "henry", "cup", "glass"])
test_trie.get_user_input


#make_selector(@current_substring, selection, user_suggestions)
binding.pry
''
