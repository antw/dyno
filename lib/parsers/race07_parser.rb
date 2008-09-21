require 'inifile'

module Dyno::Parsers
  ##
  # Parses a Race 07 results file (which appears to be some variation of the
  # ini format).
  #
  # TODO: Remove dependency on inifile and write our own ini parser so that:
  #   * we can extract individual lap information.
  #   * we don't have to have a results file on disk.
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
      parse_competitors!
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
      end
    end

    ##
    # Extracts information about each of the competitors.
    #
    def parse_competitors!
      finished_competitors = []
      dnf_competitors      = []

      @raw.sections.each do |section_name|
        # Competitor sections are named SlotNNN.
        next unless section_name =~ /Slot\d\d\d/

        values = @raw[section_name]

        competitor = Dyno::Competitor.new(values['Driver'],
         :vehicle  => values['Vehicle'],
         :laps     => values['Laps'].to_i
        )

        # Some results files have a blank ID.
        if values['SteamId'] && values['SteamId'] =~ /\d+/
          competitor.uid = values['SteamId'].to_i
        end

        best = values['BestLap'].split( /:|\./ )
        competitor.best_lap = best[1].to_f + ( best[0].to_i * 60 ) + "0.#{best[2]}".to_f

        if values['RaceTime'] == 'DNF'
          competitor.race_time = 'DNF'
          dnf_competitors << competitor
        else
          time = values['RaceTime'].split( /:|\./ )

          competitor.race_time = time[2].to_f + ( time[1].to_i * 60 ) +
            ( time[0].to_i * 60 * 60 ) + "0.#{time[3]}".to_f

          finished_competitors << competitor
        end
      end

      # Sort finished competitors by their race time, lowest (P1) first.
      finished_competitors = finished_competitors.sort_by { |c| c.race_time }

      # ... and DNF'ed competitors by how many laps they've done.
      dnf_competitors = dnf_competitors.sort_by { |c| c.laps }.reverse!

      # TODO: Sort DNF competitors inversely by how much of of the race distance they covered.

      # Finally let's assign their finishing positions.
      competitors = finished_competitors + dnf_competitors
      competitors.each_with_index { |c, i| c.position = i + 1 }

      # All done!
      @event.competitors = competitors
    end
  end
end