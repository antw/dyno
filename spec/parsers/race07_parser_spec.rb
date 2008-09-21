require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe Dyno::Parsers::Race07Parser do

  it 'should respond to .parse' do
    Dyno::Parsers::Race07Parser.should respond_to(:parse)
  end

  it 'should respond to .parse_file' do
    Dyno::Parsers::Race07Parser.should respond_to(:parse_file)
  end

  it 'should respond to #parse' do
    Dyno::Parsers::Race07Parser.public_instance_methods.should include('parse')
  end

  # --------------
  # Event parsing.

  describe 'parse_event!' do
    before(:all) do
      @event = Dyno::Parsers::Race07Parser.parse_file(
        'spec/fixtures/race07/header_only.ini'
      )
    end

    it 'should set the game' do
      @event.game.should == 'Race 07'
    end

    it 'should correctly set the game version' do
      # 1.1.1.14
      @event.game_version.should == '1.1.1.14'
    end

    it 'should correctly set the event time' do
      # 2008/09/13 23:00:50
      @event.time.should == Time.local(2008, 9, 13, 23, 00, 50)
    end

    it 'should correctly set the track' do
      @event.track.should == 'Anderstorp 2007'
    end

    it 'should not set the track if one could not be discerned' do
      event = Dyno::Parsers::Race07Parser.parse_file(
        'spec/fixtures/race07/header_no_track.ini'
      )

      event.track.should be_nil
    end

    it 'should whine loudly if there is no "Header" section' do
      lambda {
        Dyno::Parsers::Race07Parser.parse_file(
          'spec/fixtures/race07/no_header_section.ini'
        )
      }.should raise_error(Dyno::MalformedInputError)
    end
  end

  # -------------------
  # Competitor parsing.

  describe 'parse_competitors!' do
    before(:all) do
      @event = Dyno::Parsers::Race07Parser.parse_file(
        'spec/fixtures/race07/single_driver.ini'
      )
    end

    it 'should set the driver name correctly' do
      @event.competitors.first.name.should == 'Gabriel Lloyd'
    end

    it 'should set the vehicle correctly' do
      @event.competitors.first.vehicle.should == 'Chevrolet Lacetti 2007'
    end

    it 'should set the steam id (uid) correctly' do
      @event.competitors.first.uid.should == 635
    end

    it 'should not set the steam id if one is not present' do
      event = Dyno::Parsers::Race07Parser.parse_file(
        'spec/fixtures/race07/no_steam_id.ini'
      )

      event.competitors.first.uid.should be_nil
    end

    it 'should set the lap count correctly' do
      @event.competitors.first.laps.should == 13
    end

    it 'should convert the race time to a float' do
      @event.competitors.first.race_time.should == 1296.73
    end

    it 'should convert the best lap time to a float' do
      @event.competitors.first.best_lap.should == 97.825
    end

    it 'should correctly sort drivers by their finishing time, and assign their position' do
      event = Dyno::Parsers::Race07Parser.parse_file(
        'spec/fixtures/race07/full.ini'
      )

      event.competitors[0].name.should == 'Gabriel Lloyd'
      event.competitors[0].position.should == 1

      event.competitors[1].name.should == 'Jerry Lalich'
      event.competitors[1].position.should == 2

      event.competitors[2].name.should == 'Mark Voss'
      event.competitors[2].position.should == 3

      event.competitors[3].name.should == 'Corey Ball'
      event.competitors[3].position.should == 4
    end
  end
end