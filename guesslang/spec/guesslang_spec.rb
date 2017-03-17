require 'cover_me'

describe 'guesslang.rb' do
  it 'should guess a french file specified on the command line' do
    `./guesslang.rb --file spec/french_guessme.txt`.strip.should  == 'french'
  end

  #it 'should guess an english file specified on the command line' do
    #`./guesslang.rb --file spec/english_guessme.txt`.strip.should  == 'english'
  #end

  it 'should seed from the files specified on the command line' do
    `./guesslang.rb --file spec/guessme.txt spec/lang_a.1`.strip.should == 'lang_a'
  end
end
