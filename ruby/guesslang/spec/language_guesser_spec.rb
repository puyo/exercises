require 'cover_me'
require 'language_guesser'

describe LanguageGuesser do
  describe '#add_seed' do
    it 'should not raise an error given languages and inputs' do
      lambda { subject.add_seed('foo', 'one two three') }.should_not raise_error
    end
  end

  describe '#prepare_seeds' do
    it 'should not raise an error' do
      lambda { subject.prepare_seeds }.should_not raise_error
    end
  end

  describe '#guess_language' do
    context 'with seed data' do
      before(:each) do
        subject.add_seed('foo', 'one two three')
        subject.add_seed('bar', 'three four five')
        subject.prepare_seeds
      end

      it 'should guess the right language given a single word in that language' do
        subject.guess_language('one').should == 'foo'
        subject.guess_language('four').should == 'bar'
      end

      it 'should guess the right language given some shared words and some from one language' do
        subject.guess_language('one two three').should == 'foo'
        subject.guess_language('three four five').should == 'bar'
      end

      it 'should return "unknown" if none of the words are recognised' do
        subject.guess_language('a b c d e f g').should == 'unknown'
      end

      it 'should return the right language even if most of the words are unrecognised' do
        subject.guess_language('one a b c d e f g').should == 'foo'
      end
    end
  end
end
