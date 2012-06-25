require "formotion/version"
require 'bubble-wrap/core'

Dir.glob(File.join(File.dirname(__FILE__), 'formotion/**/*.rb')).each do |file|
  BW.require file
end
