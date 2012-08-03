module Formotion
  class FormableController < Formotion::FormController
    extend BW::KVO
    include BW::KVO

    attr_accessor :model

    def initWithModel(model)
      self.initWithForm(model.to_form)
      self.model = model
      self.form.sections.each { |section|
        section.rows.each { |row|
          observe(row, "value") do |old_value, new_value|
            self.model.send("#{row.key}=", new_value)
          end
        }
      }
      self
    end
  end
end