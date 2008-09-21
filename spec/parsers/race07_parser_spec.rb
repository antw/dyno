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
end