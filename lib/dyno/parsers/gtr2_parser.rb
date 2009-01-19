module Dyno::Parsers
  ##
  # Parses a Race 07 results file which are almost identical to Race 07 files.
  #
  class GTR2Parser < Race07Parser
    def self.parse_file( filename )
      # GTR2 files start with a line which isn't valid INI; remove it.
      parse( IniParse.parse(
        File.read( filename ).sub!(/^.*\n/, '')
      ) )
    end
  end
end
