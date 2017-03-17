#!/usr/bin/env ruby

require_relative './stereogram'
require 'test/unit'

class StereoGramTest < Test::Unit::TestCase
  FIXTURES = [
    ['pyramid', 'the t reesareouttog e tyouandbreakyo  urbabieswiththeirbranches'],
    ['tree', 'the t reesareouttog e tyouandbreakyo  urbabieswiththeirbranches'],
  ].freeze

  def test_tree
    FIXTURES.each do |testname, text|
      input = File.read(testname)
      s = Stereogram.new(input, text, 10, 0, 0)
      result = ''
      s.output(result)
      expected = File.read("#{testname}.expected")
      File.open("#{testname}.actual", 'w') do |f|
        f.puts result
      end
      expected.lines.zip(result.lines).each do |eline, rline|
        assert_equal(eline, rline, 'Did not match')
      end
      assert_equal(expected, result, 'Did not match')
    end
  end
end
