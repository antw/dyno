module Dyno::Parsers
  ##
  # Parses a Race 07 results file (which appears to be some variation of the
  # ini format).
  #
  class Race07Parser
    ##
    # Takes a file path and parses it.
    #
    # @param [String] filename
    #   The path to the results file.
    # @param [Symbol] mode
    #   The order in which competitors should be ordered. Race mode uses the
    #   normal means, while :lap will order by their fastest lap.
    #
    def self.parse_file( filename, mode = :race )
      parse( IniParse.open( filename ), mode )
    end

    ##
    # Takes an IniParse::Document instance, parses the contents, and returns a
    # Dyno::Event containing your results.
    #
    # @param  [IniParse::Document] results The results.
    # @return [Dyno::Event]
    #
    def self.parse( results, mode = :race )
      new( results, mode ).parse
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
    # Takes an IniParse::Document instance and parses the contents.
    #
    # @param [IniParse::Document] results The results.
    #
    def initialize( results, mode = :race )
      @raw, @mode = results, mode
    end

    ##
    # Extracts the event information from the results.
    #
    def parse_event!
      raise Dyno::MalformedInputError unless @raw.has_section?('Header')

      @event = Dyno::Event.new( :game => @raw['Header']['Game'] )
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

      @raw.each do |section|
        # Competitor sections are named SlotNNN.
        next unless section.key =~ /Slot\d\d\d/

        competitor = Dyno::Competitor.new(section['Driver'],
         :vehicle  => section['Vehicle'],
         :laps     => section['Laps'].to_i
        )

        # Some results files have a blank ID.
        if section['SteamId'] && section['SteamId'].kind_of?(Numeric)
          competitor.uid = section['SteamId']
        end

        # Sort out the competitors lap times.
        competitor.best_lap = lap_time_to_float(section['BestLap'])

        competitor.lap_times = section['Lap'].map do |lap|
          lap = lap.gsub(/\((.*)\)/, '\1')
          lap_time_to_float(lap.split(',').last.strip)
        end

        if section['RaceTime'] =~ /D(NF|S?Q)/
          $1 == 'NF' ? competitor.dnf! : competitor.dsq!
          competitor.race_time = 0
          dnf_competitors << competitor
        else
          time = section['RaceTime'].split( /:|\./ )

          competitor.race_time = time[2].to_f + ( time[1].to_i * 60 ) +
            ( time[0].to_i * 60 * 60 ) + "0.#{time[3]}".to_f

          finished_competitors << competitor
        end
      end

      if @mode == :race
        # Sort finished competitors by their race time, lowest (P1) first.
        finished_competitors = finished_competitors.sort_by do |c|
          [ - c.laps, c.race_time ]
        end
      else
        # Sort finished competitors by their best lap time.
        finished_competitors = finished_competitors.sort_by do |c|
          c.best_lap
        end
      end

      # ... and DNF'ed competitors by how many laps they've done.
      dnf_competitors = dnf_competitors.sort_by { |c| c.laps }.reverse!

      # Finally let's assign their finishing positions.
      competitors = finished_competitors + dnf_competitors
      competitors.each_with_index { |c, i| c.position = i + 1 }

      # All done!
      @event.competitors = competitors
    end

    # Converts a lap time (in the format of M:SS:SSS) to a float.
    def lap_time_to_float(time)
      time = time.split( /:|\./ )
      time[1].to_f + ( time[0].to_i * 60 ) + "0.#{time[2]}".to_f
    end
  end
end