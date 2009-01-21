require 'rubygems'
require 'time'
require 'iniparse'
require 'libxml'

module Dyno
  # Base exception class.
  class DynoError < StandardError; end

  # Raised if an input source couldn't be parsed, or was missing something.
  class MalformedInputError < DynoError; end
end

dir = File.join( File.dirname(__FILE__), "dyno" )

require File.join( dir, "competitor" )
require File.join( dir, "event" )

# Parsers
require File.join( dir, "parsers", "race07_parser" )
require File.join( dir, "parsers", "gtr2_parser" )
require File.join( dir, "parsers", "rfactor_parser" )
