module Dyno
  class Event
    attr_accessor :time, :game, :game_version, :track, :competitors

    ##
    # @param [Hash] properties Event information.
    #
    def initialize(properties = {})
      @time  = properties.fetch( :time, Time.now )
      @track = properties[:track]
      @game  = properties[:game]
      @game_version = properties[:game_version]
      @competitors  = properties.fetch( :competitors, [] )
    end
  end
end
