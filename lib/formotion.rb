require File.expand_path(File.join(File.dirname(__FILE__), "formotion/version"))
require 'bubble-wrap/core'
require 'bubble-wrap/camera'

require 'motion-require'

Motion::Require.all(Dir.glob(File.expand_path('../formotion/**/*.rb', __FILE__)))