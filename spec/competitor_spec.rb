require File.dirname(__FILE__) + '/spec_helper'

describe Dyno::Competitor do
  before(:each) do
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

  it 'should respond_to #finished?' do
    @competitor.should respond_to(:finished?)
  end

  it 'should respond_to #dnf?' do
    @competitor.should respond_to(:dnf?)
  end

  it 'should respond_to #dsq?' do
    @competitor.should respond_to(:dsq?)
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

  # ---------------------------------
  # finished / dnf / disqualification

  describe 'when the competitor finished the event' do
    it 'should return true to #finished?' do
      @competitor.should be_finished
    end

    it 'should return false to #dnf?' do
      @competitor.should_not be_dnf
    end

    it 'should return false to #dsq?' do
      @competitor.should_not be_dsq
    end
  end

  describe 'when the competitor did not finish' do
    before { @competitor.dnf! }

    it 'should return false to #finished?' do
      @competitor.should_not be_finished
    end

    it 'should return true to #dnf?' do
      @competitor.should be_dnf
    end

    it 'should return false to #dsq?' do
      @competitor.should_not be_dsq
    end
  end

  describe 'when the competitor was disqualified' do
    before { @competitor.dsq! }

    it 'should return false to #finished?' do
      @competitor.should_not be_finished
    end

    it 'should return false to #dnf?' do
      @competitor.should_not be_dnf
    end

    it 'should return true to #dsq?' do
      @competitor.should be_dsq
    end
  end

end