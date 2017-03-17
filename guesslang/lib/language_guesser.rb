class LanguageGuesser
  def initialize
    @histogram_for_word = Hash.new{|h,k| h[k] = Histogram.new }
    @language_for_word = {}
  end

  def add_seed(language, input)
    words(input).each do |word|
      @histogram_for_word[word][language] += 1
    end
  end

  def prepare_seeds
    @histogram_for_word.each do |word, histogram|
      @language_for_word[word] = histogram.most_common
    end
  end

  def guess_language(input)
    result = Histogram.new
    words(input).each do |word|
      language = @language_for_word[word]
      result[language] += 1 if language
    end
    result.most_common || 'unknown'
  end

  private

  def words(input)
   input.to_s.downcase.split(/\W+/)
  end

  class Histogram < Hash
    def initialize
      super {|h,k| h[k] = 0 }
    end

    def most_common
      tuple = sort_by{|value, count| -count }.first
      tuple && tuple.first # return nil if histogram is empty
    end
  end
end
