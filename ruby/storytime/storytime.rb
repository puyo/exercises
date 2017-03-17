require 'pp'
require_relative './deep_merge'

class Rule
  protected

  def knowledge_matches?(old, new)
    if old.is_a?(Hash) && new.is_a?(Hash)
      result = true
      new.each do |k,v|
        if old.has_key?(k)
          result &&= knowledge_matches?(old[k], new[k])
        end
      end
      result
    elsif old.nil?
      true
    elsif new.nil?
      true
    else
      old == new
    end
  end

  private

  attr_reader :new_knowledge
end

class Property < Rule
  def initialize(new_knowledge)
    @new_knowledge = new_knowledge
  end

  def incorporate_knowledge(knowledge, name:)
    knowledge.deep_merge(name => @new_knowledge)
  end

  def expansion(key)
    @new_knowledge[key]
  end

  def match?(name:, property:, knowledge:)
    @new_knowledge.has_key?(property) && knowledge_matches?(knowledge, name => @new_knowledge)
  end
end

class Expansion < Rule
  def initialize(key, expansion, new_knowledge={})
    @key = key
    @expansion = expansion
    @new_knowledge = new_knowledge
  end

  def incorporate_knowledge(knowledge)
    knowledge.deep_merge(@new_knowledge)
  end

  def expansion
    @expansion
  end

  def match?(key:, knowledge:)
    @key == key && knowledge_matches?(knowledge, @new_knowledge)
  end

  attr_reader :key
end

class RuleSet
  def initialize(expansions:, properties:)
    @expansions = expansions
    @properties = properties
  end

  def expansion_matches(key:, knowledge:)
    @expansions.select{|e| e.match?(key: key, knowledge: knowledge) }
  end

  def property_matches(name:, property:, knowledge:)
    @properties.select{|p| p.match?(name: name, property: property, knowledge: knowledge) }
  end
end

class Story
  def resolve(sentence, rule_set, knowledge)
    pp sentence: sentence, knowledge: knowledge
    return sentence if resolved?(sentence)
    return sentence if sentence.nil?
    if m = sentence.match(/^(.*?){([\w.]+?)}(.*)$/)
      preamble, key, remainder = m[1], m[2], m[3]
      parts = key.split('.')
      if parts.size == 2 # name.property
        name, property = parts
        for p in rule_set.property_matches(name: name, property: property, knowledge: knowledge).shuffle
          new_knowledge = p.incorporate_knowledge(knowledge, name: name)
          middle = p.expansion(property)
          if new_sentence = resolve(preamble + middle + remainder, rule_set, new_knowledge)
            return new_sentence
          end
        end
      else # key
        for e in rule_set.expansion_matches(key: key, knowledge: knowledge).shuffle
          new_knowledge = e.incorporate_knowledge(knowledge)
          if new_sentence = resolve(preamble + e.expansion + remainder, rule_set, new_knowledge)
            return new_sentence
          end
        end
      end
    end
    return nil
  end

  def resolved?(sentence)
    not (sentence.nil? || sentence.include?('{'))
  end
end

# ----------------------------------------------------------------------

rules = RuleSet.new(
  expansions: [
    Expansion.new('story', '{sentence} {sentence}'),
    Expansion.new('sentence', '{p.name} went to bed because {p.heshe} was tired.', 'p' => {'class' => 'character'}),
    Expansion.new('sentence', '{x.name} went to the shop to get {x.hisher} shopping.', 'x' => {'class' => 'character'}),
  ],
  properties: [
    Property.new('name' => 'Tracy', 'gender' => 'female', 'class' => 'character'),
    Property.new('name' => 'Len', 'gender' => 'male', 'class' => 'character'),
    Property.new('gender' => 'male', 'class' => 'character', 'heshe' => 'he', 'hisher' => 'his', 'hishers' => 'his', 'himher' => 'him'),
    Property.new('gender' => 'female', 'class' => 'character', 'heshe' => 'she', 'hisher' => 'her', 'hishers' => 'hers', 'himher' => 'her'),
  ]
)

story = Story.new

puts story.resolve('{story}', rules, {})
