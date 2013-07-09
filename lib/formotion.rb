require File.expand_path(File.join(File.dirname(__FILE__), "formotion/version"))
require 'bubble-wrap/core'
require 'bubble-wrap/font'
require 'bubble-wrap/camera'

require 'motion-require'

Motion::Require.all(Dir.glob(File.expand_path('../formotion/**/*.rb', __FILE__)))

Motion::Project::App.setup do |app|
  app.frameworks<<'CoreLocation' unless app.frameworks.include?('CoreLocation')
  app.frameworks<<'MapKit' unless app.frameworks.include?('MapKit')
  
  app.resources_dirs << File.join(File.dirname(__FILE__), '../resources')
end
