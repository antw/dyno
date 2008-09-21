require 'inifile'

module Dyno::Parsers
  ##
  # Parses a Race 07 results file (which appears to be some variation of the
  # ini format).
  #
  # TODO: Remove dependency on inifile and write our own ini parser so that:
  #   * we can extract individual lap information.
  #   * we don't have to have a file on disk.
  #
  class Race07Parser
    ##
    # Takes a file path and parses it.
    #
    # @param [String] filename The path to the results file.
    #
    def self.parse_file( filename )
      parse( IniFile.load( filename ) )
    end

    ##
    # Takes an IniFile instance, parses the contents, and returns a
    # Dyno::Event containing your results.
    #
    # @param  [IniFile] results The results.
    # @return [Dyno::Event]
    #
    def self.parse( results )
      new( results ).parse
    end

    ##
    # Returns your parsed event and competitor information.
    #
    def parse
      parse_event!
      # parse_competitors!
      @event
    end

    #######
    private
    #######

    ##
    # Takes an IniFile instance and parses the contents.
    #
    # @param  [IniFile] results The results.
    #
    def initialize( results )
      @raw = results
    end

    ##
    # Extracts the event information from the results.
    #
    def parse_event!
      raise Dyno::MalformedInputError unless @raw.has_section?('Header')

      @event = Dyno::Event.new( :game => 'Race 07' )
      @event.time = Time.parse( @raw['Header']['TimeString'] )
      @event.game_version = @raw['Header']['Version']

      # Extract the track name from Race/Scene
      if @raw.has_section?('Race') && @raw['Race']['Scene']
        @event.track = @raw['Race']['Scene'].split( '\\' )[-2].gsub( /[_-]+/, ' ' )
      else
        @event.track = 'Unknown'
      end
    end
  end
end