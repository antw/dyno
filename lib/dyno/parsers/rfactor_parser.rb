module Dyno::Parsers
  ##
  # Parses a rFactor results files.
  #
  class RFactorParser
    ##
    # Takes a file path and parses it.
    #
    # @param [String] filename The path to the results file.
    #
    def self.parse_file( filename, mode = nil )
      xmlparser = LibXML::XML::Parser.new
      xmlparser.file = filename
      parse( xmlparser.parse )
    end

    ##
    # Takes a LibXML::XML::Document instance, parses the contents, and returns
    # a Dyno::Event containing your results.
    #
    # @param  [LibXML::XML::Document] results The results.
    # @return [Dyno::Event]
    #
    def self.parse( results, mode = nil )
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
    # Takes a LibXML::XML::Document instance and parses the contents.
    #
    # @param [LibXML::XML::Document] results The results.
    #
    def initialize( results )
      @doc   = results
      @stack = []
    end

    ##
    # Extracts the event information from the results.
    #
    def parse_event!
      unless results = @doc.find_first('//RaceResults')
        raise Dyno::MalformedInputError, 'No //RaceResults node.'
      end

      with_node(results) do
        @event = Dyno::Event.new(
          :game         => clean(value('Mod').gsub(/\.rfm$/, '')),
          :track        => clean(value('TrackCourse')),
          :game_version => value('GameVersion')
        )

        # Sort out the event time - the rFactor results format has more than
        # one TimeString node. The first appears to be when the server was
        # started - we need the time of the event itself, which is held under
        # the Race, Qualify or Warmup node.
        if event_node = \
              (@doc.find_first('//RaceResults/Race')    ||
               @doc.find_first('//RaceResults/Qualify') ||
               @doc.find_first('//RaceResults/Warmup'))
          with_node(event_node) do
            @event.time = Time.parse( value('TimeString') )
          end
        end
      end
    end

    ##
    # Extracts information about each of the competitors.
    #
    def parse_competitors!
      @doc.find('//Driver').each do |section|
        with_node(section) do
          competitor = Dyno::Competitor.new(value('Name'),
            :vehicle => clean(value('CarType')),
            :laps    => value('Laps').to_i
          )

          competitor.position  = value('Position').to_i
          competitor.best_lap  = lap_time_to_float( value('BestLapTime') )
          competitor.race_time = lap_time_to_float( value('FinishTime') )

          competitor.lap_times = section.find('Lap').map do |lap|
            lap_time_to_float( lap.content )
          end

          if value('FinishStatus') =~ /D(NF|S?Q)/
            $1 == 'NF' ? competitor.dnf! : competitor.dsq!
          end

          @event.competitors << competitor
        end
      end

      @event.competitors = @event.competitors.sort_by { |c| c.position }
    end

    # --
    # Utility stuff
    # ++

    def value( node ) # :nodoc:
      if found = @stack.last.find_first( node )
        found.content
      else
        nil
      end
    end

    def clean( value ) # :nodoc:
      value.gsub(/[-_]/, ' ').squeeze(' ') unless value.nil?
    end

    def with_node( node ) # :nodoc:
      @stack.push( node )
      yield
      @stack.pop
    end

    # Converts a lap time (in the format of M:SS:SSS) to a float.
    def lap_time_to_float(time) # :nodoc:
      (time.nil? || time == '--.----') ? 0.0 : Float(time)
    end
  end
end