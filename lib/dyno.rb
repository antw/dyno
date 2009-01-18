require 'rubygems'
require 'time'
require 'iniparse'

module Dyno
  # Base exception class.
  class DynoError < StandardError; end

  # Raised if an input source couldn't be parsed, or was missing something.
  class MalformedInputError < DynoError; end
end

%w( competitor event ).each do |file|
  require File.join( File.dirname(__FILE__), "dyno", file )
end

# Parsers
require File.join( File.dirname(__FILE__), "dyno", "parsers", "race07_parser" )
require File.join( File.dirname(__FILE__), "dyno", "parsers", "gtr2_parser" )
