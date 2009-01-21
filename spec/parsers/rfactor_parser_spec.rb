require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe Dyno::Parsers::RFactorParser do

  it 'should respond to .parse' do
    Dyno::Parsers::RFactorParser.should respond_to(:parse)
  end

  it 'should respond to .parse_file' do
    Dyno::Parsers::RFactorParser.should respond_to(:parse_file)
  end

  it 'should respond to #parse' do
    Dyno::Parsers::RFactorParser.public_instance_methods.should include('parse')
  end

  # --------------
  # Event parsing.

  describe 'parse_event!' do
    before(:all) do
      @event = Dyno::Parsers::RFactorParser.parse_file(
        'spec/fixtures/rfactor/event_only.xml'
      )
    end

    it 'should set the game' do
      @event.game.should == 'JF3 2007'
    end

    it 'should correctly set the game version' do
      # 1.255
      @event.game_version.should == '1.255'
    end

    it 'should correctly set the event time' do
      # 2008/12/21 21:56:13
      @event.time.should == Time.local(2008, 12, 21, 21, 56, 13)
    end

    it 'should correctly set the track' do
      @event.track.should == 'Suzuka 2005'
    end

    it 'should whine loudly if there is no "RaceResults" node' do
      lambda {
        Dyno::Parsers::RFactorParser.parse_file(
          'spec/fixtures/rfactor/missing_root.xml'
        )
      }.should raise_error(Dyno::MalformedInputError)
    end
  end

  # -------------------
  # Competitor parsing.

  describe 'parse_competitors!' do
    before(:all) do
      @event = Dyno::Parsers::RFactorParser.parse_file(
        'spec/fixtures/rfactor/single_driver.xml'
      )
    end

    it 'should set the driver name correctly' do
      @event.competitors.first.name.should == 'Zach Evans'
    end

    it 'should set the vehicle correctly' do
      @event.competitors.first.vehicle.should == 'JF3 2007'
    end

    it 'should set the lap count correctly' do
      @event.competitors.first.laps.should == 17
    end

    it 'should convert the race time to a float' do
      @event.competitors.first.race_time.should == 2049.6411
    end

    it 'should convert the best lap time to a float' do
      @event.competitors.first.best_lap.should == 119.3561
    end

    it "should correctly set the competitors lap times" do
      @event.competitors.first.lap_times.should == [
        130.5218, # <Lap num="1"  [...] >130.5218</Lap>
        119.7023, # <Lap num="2"  [...] >119.7023</Lap>
        120.2195, # <Lap num="3"  [...] >120.2195</Lap>
        119.6123, # <Lap num="4"  [...] >119.6123</Lap>
        120.2735, # <Lap num="5"  [...] >120.2735</Lap>
        119.6417, # <Lap num="6"  [...] >119.6417</Lap>
        119.6810, # <Lap num="7"  [...] >119.6810</Lap>
        119.9735, # <Lap num="8"  [...] >119.9735</Lap>
        120.0426, # <Lap num="9"  [...] >120.0426</Lap>
        120.0213, # <Lap num="10" [...] >120.0213</Lap>
        120.5605, # <Lap num="11" [...] >120.5605</Lap>
        119.3561, # <Lap num="12" [...] >119.3561</Lap>
        120.2949, # <Lap num="13" [...] >120.2949</Lap>
        120.5171, # <Lap num="14" [...] >120.5171</Lap>
        120.1576, # <Lap num="15" [...] >120.1576</Lap>
        119.3593, # <Lap num="16" [...] >119.3593</Lap>
        119.7063  # <Lap num="17" [...] >119.7063</Lap>
      ]
    end

    it 'should correctly sort drivers by their finishing time, and assign their position' do
      event = Dyno::Parsers::RFactorParser.parse_file(
        'spec/fixtures/rfactor/full.xml'
      )

      [ [ "Zach Evans",                     1 ],
        [ "Archie Gray",                    2 ],
        [ "Jonathan Mistry",                3 ],
        [ "Sjef Petersen",                  4 ],
        [ "Topi Keskinen",                  5 ],
        [ "Evan Hanson",                    6 ],
        [ "Tom M. Hall",                    7 ],
        [ "Oliver Baker",                   8 ],
        [ "Jamie Norman",                   9 ],
        [ "Haruaki Gotou",                 10 ],
        [ "Hiromitsu Kishimoto",           11 ],
        [ "Edgar Est\303\251vez Guajardo", 12 ],
        [ "Sabahudin Smerkolj",            13 ]
      ].each do |(name, position)|
        event.competitors[position - 1].name.should == name
        event.competitors[position - 1].position.should == position
      end
    end

    it 'should set a competitor as "did not finish" when necessary' do
      Dyno::Parsers::RFactorParser.parse_file(
        'spec/fixtures/rfactor/single_driver_dnf.xml'
      ).competitors.first.should be_dnf
    end

    it 'should set a competitor as "disqualified" when necessary' do
      Dyno::Parsers::RFactorParser.parse_file(
        'spec/fixtures/rfactor/single_driver_dsq.xml'
      ).competitors.first.should be_dsq
    end

    describe 'when parsing ARCA results' do
      it 'should not raise an error' do
        lambda{
          Dyno::Parsers::RFactorParser.parse_file(
            'spec/fixtures/rfactor/arca.xml'
          )
        }.should_not raise_error
      end

      it 'should have the correct number of competitors' do
        Dyno::Parsers::RFactorParser.parse_file(
          'spec/fixtures/rfactor/arca.xml'
        ).competitors.size.should == 3
      end
    end
  end
end