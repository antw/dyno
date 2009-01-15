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

      [:uid, :position, :vehicle, :laps, :race_time, :best_lap].each do |prop|
        instance_variable_set "@#{prop}", properties[prop]
      end
    end
  end
end