#################
#
# Formotion::FormController
# Use #initWithForm to create a view controller
# loaded with your form.
#
#################
module Formotion
  class FormController < UITableViewController
    attr_accessor :form

    # Initializes controller with a form
    # PARAMS form.is_a? [Hash, Formotion::Form]
    # RETURNS An instance of Formotion::FormController
    def initWithForm(form)
      self.initWithStyle(UITableViewStyleGrouped)
      self.form = form
      self.view.setEditing true, animated: true
      self.view.allowsSelectionDuringEditing = true
      self
    end

    # Set the form; ensure it is/can be converted to Formotion::Form
    # or raises an exception.
    def form=(form)
      if form.is_a? Hash
        form = Formotion::Form.new(form)
      elsif not form.is_a? Formotion::Form
        raise Formotion::InvalidClassError, "Attempted FormController.form = #{form.inspect} should be of type Formotion::Form or Hash"
      end
      @form = form
    end

    def viewDidLoad
      super

      self.title = self.form.title

      # Triggers this block when the enter key is pressed
      # while editing the last text field.
      @form.sections[-1] && @form.sections[-1].rows[-1].on_enter do |row|
        if row.text_field
          @form.submit
          row.text_field.resignFirstResponder
        end
      end

      # Setting @form.controller assigns
      # @form as the datasource and delegate
      # and reloads the data.
      @form.controller = self
    end

    # Subview Methods
    def push_subform(form)
      @subform_controller = self.class.alloc.initWithForm(form)

      if self.navigationController
        self.navigationController.pushViewController(@subform_controller, animated: true)
      else
        self.presentModalViewController(@subform_controller, animated: true)
      end
    end

    def pop_subform
      if self.navigationController
        self.navigationController.popViewControllerAnimated true
      else
        self.dismissModalViewControllerAnimated true
      end
    end
  end
end