require "formotion/version"
require 'bubble-wrap/core'
require 'bubble-wrap/camera'

BW.require File.expand_path('../formotion/**/*.rb', __FILE__) do
  base_row_type = 'lib/formotion/row_type/base.rb'

  # hack to make sure base row type is compiled early
  file('lib/formotion/base.rb').depends_on base_row_type

  row_types = Dir.glob('lib/formotion/row_type/**/*.rb')
  row_types.each {|file|
    next if file == base_row_type
    file(file).depends_on base_row_type
  }

  ['date_row', 'email_row', 'number_row', 'phone_row'].each {|file|
    file("lib/formotion/row_type/#{file}.rb").depends_on 'lib/formotion/row_type/string_row.rb'
  }
  ['submit_row', 'back_row'].each {|file|
    file("lib/formotion/row_type/#{file}.rb").depends_on 'lib/formotion/row_type/button.rb'
  }

  ['form/form.rb', 'row/row.rb', 'section/section.rb'].each {|file|
    file("lib/formotion/#{file}").depends_on 'lib/formotion/base.rb'
  }
  file("lib/formotion/controller/form_controller.rb").depends_on 'lib/formotion/patch/ui_text_field.rb'
end