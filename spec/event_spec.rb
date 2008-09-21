require File.dirname(__FILE__) + '/spec_helper'

describe Dyno::Event do
  before(:all) do
    @event = Dyno::Event.new
  end

  it 'should have a +time+ accessor' do
    @event.should respond_to(:time)
    @event.should respond_to(:time=)
  end

  it 'should have a +track+ accessor' do
    @event.should respond_to(:track)
    @event.should respond_to(:track=)
  end

  it 'should have a +game+ accessor' do
    @event.should respond_to(:game)
    @event.should respond_to(:game=)
  end

  it 'should have a +game_version+ accessor' do
    @event.should respond_to(:game_version)
    @event.should respond_to(:game_version=)
  end

  it 'should have a +competitors+ accessor' do
    @event.should respond_to(:competitors)
    @event.should respond_to(:competitors=)
  end

  # -----------
  # #initialize

  it 'should use the given values when creating a Event' do
    event = Dyno::Event.new(
      :time  => Time.now - 10,
      :track => "Anderstorp 2007",
      :game  => "Event 07",
      :game_version => "1.1.1.14",
      :competitors  => [1]
    )

    event.time.should be_close(Time.now - 10, 0.5)
    event.track.should == "Anderstorp 2007"
    event.game.should == "Event 07"
    event.game_version.should == "1.1.1.14"
    event.competitors.should  == [1]
  end

  it 'should set a default time if none is given' do
    Dyno::Event.new.time.should be_close(Time.now, 1)
  end

  it 'should default competitors to [] if none are given' do
    Dyno::Event.new.competitors.should == []
  end
end