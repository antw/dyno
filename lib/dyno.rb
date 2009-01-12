require 'rubygems'
require 'time'

module Dyno
  # Base exception class.
  class DynoError < StandardError; end

  # Raised if an input source couldn't be parsed, or was missing something.
  class MalformedInputError < DynoError; end
end

%w( competitor event ).each do |file|
  require File.join( File.dirname(__FILE__), "dyno", file )
end

Dir["#{ File.dirname(__FILE__) }/dyno/parsers/*_parser.rb"].sort.each do |parser|
  require parser
end
