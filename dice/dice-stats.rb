#! /usr/bin/env ruby

class Dice
  class << self
    def roll(type)
      rand(type) + 1
    end

    def roll_and_add(number, type)
      result = 0
      number.times do
        result += roll(type)
      end
      result
    end

    def wod(skill, target)
      result = 0
      safe = false
      skill.times do
        die_result = roll(10)
        if die_result == 1
          result -= 1
        elsif die_result >= target
          result += 1
          safe = true
        end
      end
      if result.negative? && safe
        result = 0
      end
      result
    end
  end
end

def wod_test
  skill = 3
  target = 5
  range = skill
  rolls = 10_000

  puts 'Skill = ' + skill.to_s
  puts 'Target = ' + target.to_s

  results = Array.new(rolls)
  freq = Hash.new { |h, k| h[k] = 0 }
  freq_botch = Hash.new { |h, k| h[k] = 0 }

  # Roll lots of times to test.
  rolls.times do
    result = Dice.wod(skill, target)
    if result.negative?
      freq_botch[-result] += 1
    else
      freq[result] += 1
    end
    results << result
  end

  # Print results.
  range.times do |i|
    puts 'F(' + (i - range - 1).to_s + ') = ' + (freq_botch[range - i + 1] * 100.0 / rolls).to_s + '%'
  end
  range.times do |i|
    puts 'F(' + i.to_s + ') = ' + (freq[i] * 100.0 / rolls).to_s + '%'
  end
end

wod_test
#p Dice.roll_and_add(6, 10)
