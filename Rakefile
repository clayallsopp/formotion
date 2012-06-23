$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bubble-wrap'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Formation'
  vendors = ['../Condom/**/*.rb', 'lib/**/*.rb']
  vendor_files = vendors.collect {|path| Dir.glob(File.join(app.project_dir, path)) }.reduce(:+)
  app.files = vendor_files + app.files
end
