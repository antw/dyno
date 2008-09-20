module Dyno
end

%w( competitor event ).each do |file|
  require File.join( File.dirname(__FILE__), file )
end
