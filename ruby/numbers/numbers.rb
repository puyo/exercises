module NumToEnglish
  class << self

    # Given 30_321, produces ["thirty thousand", "three hundred", "twenty-one"]
    def to_en(val)
      case val
      when 0..9 then UNIT_WORDS[val]       # special cases in English
      when 10..19 then TEEN_WORDS[val]     # special cases in English
      when 20..99 then to_en_tens(val)     # like "twenty-three" or "twenty"
      else english_list(to_en_array(val))  # general case for larger numbers like "one hundred and twenty-three"
      end
    end

    private

    BREAK_WORDS = {
      1_000_000_000 => 'trillion',
      1_000_000 => 'million',
      1_000 => 'thousand',
      100 => 'hundred',
      1 => nil, # we don't say 'twenty ones', we just say 'twenty'
    }.freeze

    TENS_WORDS = {
      9        => 'ninety',
      8        => 'eighty',
      7        => 'seventy',
      6        => 'sixty',
      5        => 'fifty',
      4        => 'forty',
      3        => 'thirty',
      2        => 'twenty',
    }.freeze

    TEEN_WORDS = {
      19        => 'nineteen',
      18        => 'eighteen',
      17        => 'seventeen',
      16        => 'sixteen',
      15        => 'fifteen',
      14        => 'fourteen',
      13        => 'thirteen',
      12        => 'twelve',
      11        => 'eleven',
      10        => 'ten',
    }.freeze

    UNIT_WORDS = {
      9         => 'nine',
      8         => 'eight',
      7         => 'seven',
      6         => 'six',
      5         => 'five',
      4         => 'four',
      3         => 'three',
      2         => 'two',
      1         => 'one',
      0         => 'zero',
    }.freeze

    # Given [x, y, z], produces a string "x, y and z"
    def english_list(parts)
      if parts.size == 1
        parts.first
      else
        [parts[0...-1].join(', '), parts.last].join(' and ')
      end
    end

    # For the general pattern like [x million, y thousand, z hundred]
    def to_en_array(val)
      # val => 999_520
      BREAK_WORDS
        .inject([val, []]) { |(remainder, groups), (denominator, word)|
          n, r = remainder.divmod(denominator)
          [r, groups.push([n, word])]
        }
        .last                                                 # => [[0, "trillion"], [999, "million"], [5, "hundred"], [20, nil]]
        .select { |n, _| n > 0 }                              # => [[999, "million"], [5, "hundred"], [20, nil]]
        .map { |n, word| [to_en(n), word].compact.join(' ') } # => ["nine hundred and ninety-nine thousand", "five hundred", "twenty"]
    end

    # For numbers in the range (1, 99)
    def to_en_tens(val)
      tens, units = val.divmod(10)
      [
        TENS_WORDS[tens],
        units > 0 ? UNIT_WORDS[units] : nil,
      ].compact.join('-')
    end
  end
end

# Add `to_en` method to `Fixnum`

class Fixnum
  def to_en
    NumToEnglish.to_en(self)
  end
end

# NB: Run these tests via `rspec file.rb`

if File.basename($0) == 'rspec'
  require 'rspec'

  RSpec.describe 'Fixnum.to_en' do
    specify { expect(0.to_en).to eq('zero') }
    specify { expect(1.to_en).to eq('one') }
    specify { expect(2.to_en).to eq('two') }
    specify { expect(30.to_en).to eq('thirty') }
    specify { expect(19.to_en).to eq('nineteen') }
    specify { expect(20.to_en).to eq('twenty') }
    specify { expect(21.to_en).to eq('twenty-one') }
    specify { expect(5_000_000_000.to_en).to eq('five trillion') }
    specify { expect(5_000_000_001.to_en).to eq('five trillion and one') }
    specify { expect(5_000_000_019.to_en).to eq('five trillion and nineteen') }
    specify { expect(30_020.to_en).to eq('thirty thousand and twenty') }
    specify { expect(30_521.to_en).to eq('thirty thousand, five hundred and twenty-one') }
    specify { expect(999_000.to_en).to eq('nine hundred and ninety-nine thousand') }
  end
end
