require File.dirname(__FILE__) + '/spec_helper'

describe Dyno::Competitor do
  before(:all) do
    @competitor = Dyno::Competitor.new("Jake Lucas")
  end

  it 'should have a +name+ accessor' do
    @competitor.should respond_to(:name)
    @competitor.should respond_to(:name=)
  end

  it 'should have a +uid+ accessor' do
    @competitor.should respond_to(:uid)
    @competitor.should respond_to(:uid=)
  end

  it 'should have a +position+ accessor' do
    @competitor.should respond_to(:position)
    @competitor.should respond_to(:position=)
  end

  it 'should have a +vehicle+ accessor' do
    @competitor.should respond_to(:vehicle)
    @competitor.should respond_to(:vehicle=)
  end

  it 'should have a +laps+ accessor' do
    @competitor.should respond_to(:laps)
    @competitor.should respond_to(:laps=)
  end

  it 'should have a +race_time+ accessor' do
    @competitor.should respond_to(:race_time)
    @competitor.should respond_to(:race_time=)
  end

  it 'should have a +best_lap+ accessor' do
    @competitor.should respond_to(:best_lap)
    @competitor.should respond_to(:best_lap=)
  end

  it 'should respond_to #dnf?' do
    pending do
      @competitor.should respond_to(:dnf)
    end
  end

  # ----------
  # initialize

  it 'should use the given values when creating a Event' do
    properties = {
      :uid => 1337,
      :position => 3,
      :vehicle => "BMW 320si E90 2007",
      :laps => 13,
      :race_time => "0:21:31.183",
      :best_lap => "1:37.960"
    }

    competitor = Dyno::Competitor.new("Jake Lucas", properties)
    competitor.name.should == "Jake Lucas"

    properties.each do |prop, value|
      competitor.send(prop).should == value
    end
  end

  it 'should require that a name be supplied' do
    lambda { Dyno::Competitor.new }.should raise_error(ArgumentError)
  end

end