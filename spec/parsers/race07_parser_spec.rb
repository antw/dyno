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
      @event.game.should == 'RACE 07'
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

    it "should correctly set the competitors lap times" do
      @event.competitors.first.lap_times.should == [
        110.816, # Lap=(0,    -1.000, 1:50.816)
         98.835, # Lap=(1,    89.397, 1:38.835)
         98.082, # Lap=(2,   200.213, 1:38.082)
         98.367, # Lap=(3,   299.048, 1:38.367)
         97.825, # Lap=(4,   397.131, 1:37.825)
         98.757, # Lap=(5,   495.497, 1:38.757)
         98.718, # Lap=(6,   593.322, 1:38.718)
         98.478, # Lap=(7,   692.080, 1:38.478)
         99.347, # Lap=(8,   790.797, 1:39.347)
         98.713, # Lap=(9,   889.275, 1:38.713)
         98.952, # Lap=(10,  988.622, 1:38.952)
         99.285, # Lap=(11, 1087.336, 1:39.285)
        100.555  # Lap=(12, 1186.288, 1:40.555)
      ]
    end

    it 'should set a competitor as "did not finish" when necessary' do
      Dyno::Parsers::Race07Parser.parse_file(
        'spec/fixtures/race07/single_driver_dnf.ini'
      ).competitors[0].should be_dnf
    end

    it 'should set a competitor as "disqualified" when necessary' do
      Dyno::Parsers::Race07Parser.parse_file(
        'spec/fixtures/race07/single_driver_dsq.ini'
      ).competitors[0].should be_dsq
    end

    describe 'when in race mode' do
      it 'should sort drivers by their finishing time, and assign '\
         'their position' do
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

        event.competitors[4].name.should == 'Reino Lintula'
        event.competitors[4].position.should == 5
      end
    end

    describe 'when in lap mode' do
      it 'should sort drivers by their fastest lap, and assign their ' \
         'position' do
        event = Dyno::Parsers::Race07Parser.parse_file(
          'spec/fixtures/race07/full.ini', :lap
        )

        event.competitors[0].name.should == 'Jerry Lalich'
        event.competitors[0].position.should == 1

        event.competitors[1].name.should == 'Gabriel Lloyd'
        event.competitors[1].position.should == 2

        event.competitors[2].name.should == 'Mark Voss'
        event.competitors[2].position.should == 3

        event.competitors[3].name.should == 'Corey Ball'
        event.competitors[3].position.should == 4

        event.competitors[4].name.should == 'Reino Lintula'
        event.competitors[4].position.should == 5
      end
    end

  end
end