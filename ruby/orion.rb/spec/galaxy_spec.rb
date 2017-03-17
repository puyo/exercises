require 'moo/galaxy'

describe Moo::Galaxy, 'being created' do
  it 'supports valid parameters' do
    lambda do 
      Moo::Galaxy.new
    end.should_not raise_exception
  end

  it 'advances a turn' do
    galaxy = Moo::Galaxy.new
    galaxy.create_predefined
    galaxy.advance_turn
  end
end

