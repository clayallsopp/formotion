require "formotion/version"
require 'bubble-wrap/core'

BW.require File.expand_path('../formotion/**/*.rb', __FILE__) do
  ['form.rb', 'row.rb', 'section.rb'].each {|file|
    file("lib/formotion/#{file}").depends_on 'lib/formotion/base.rb'
  }
  file("lib/formotion/form_controller.rb").depends_on 'lib/formotion/patch/ui_text_field.rb'
end