module Dyno
  class Competitor
    attr_accessor :name, :uid, :position, :vehicle, :laps, :race_time,
      :best_lap, :lap_times

    ##
    # @param [String] name The competitor's name.
    # @param [Hash]   properties Extra information about the competitor.
    #
    def initialize(name, properties = {})
      @name = name
      @lap_times = properties.fetch(:laps, [])
      @dnf = false

      [:uid, :position, :vehicle, :laps, :race_time, :best_lap].each do |prop|
        instance_variable_set "@#{prop}", properties[prop]
      end
    end

    ##
    # Returns true fi the competitor finished the event.
    #
    def finished?
      not dnf? and not dsq?
    end

    ##
    # Flags this competitor as having not completed the event.
    #
    def dnf!
      @dnf = :dnf
    end

    ##
    # Returns true if the competitor failed to finish.
    #
    def dnf?
      @dnf == :dnf
    end

    ##
    # Flags this competitor has having been disqualified from the event.
    #
    def dsq!
      @dnf = :dsq
    end

    ##
    # Returns true if the competitor was disqualified.
    #
    def dsq?
      @dnf == :dsq
    end
  end
end
