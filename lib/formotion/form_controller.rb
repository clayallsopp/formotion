#################
#
# Formotion::FormController
# Use #initWithForm to create a view controller
# loaded with your form.
#
#################
module Formotion
  class FormController < UIViewController
    attr_accessor :form
    attr_reader :table_view

    # Initializes controller with a form
    # PARAMS form.is_a? [Hash, Formotion::Form]
    # RETURNS An instance of Formotion::FormController
    def initWithForm(form)
      self.initWithNibName(nil, bundle: nil)
      self.form = form
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

      # via https://gist.github.com/330916, could be wrong.
      tabBarHeight = self.tabBarController && self.tabBarController.tabBar.bounds.size.height
      tabBarHeight ||= 0
      navBarHeight = self.navigationController && (self.navigationController.isNavigationBarHidden ? 0.0 : self.navigationController.navigationBar.bounds.size.height)
      navBarHeight ||= 0
      frame = self.view.frame
      frame.size.height = frame.size.height - navBarHeight - tabBarHeight
      self.view.frame = frame

      self.title = self.form.title

      NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillHideOrShow:', name:UIKeyboardWillHideNotification, object:nil);
      NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillHideOrShow:', name:UIKeyboardWillShowNotification, object:nil);

      @table_view = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStyleGrouped)
      self.view.addSubview @table_view

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

    # This re-sizes + scrolls the tableview to account for the keyboard size.
    # TODO: Test this on iPads, etc.
    def keyboardWillHideOrShow(note)
      last_note = @keyboard_state
      @keyboard_state = note.name
      if last_note == @keyboard_state
        return
      end

      userInfo = note.userInfo
      duration = userInfo[UIKeyboardAnimationDurationUserInfoKey].doubleValue
      curve = userInfo[UIKeyboardAnimationCurveUserInfoKey].intValue
      keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey].CGRectValue

      view_frame = @table_view.frame;

      if @keyboard_state == UIKeyboardWillHideNotification
        view_frame.size.height = self.view.bounds.size.height
      else
        view_frame.size.height -= keyboardFrame.size.height
      end

      UIView.beginAnimations(nil, context: nil)
      UIView.setAnimationDuration(duration)
      UIView.setAnimationDelay(0)
      UIView.setAnimationCurve(curve)
      UIView.setAnimationBeginsFromCurrentState(true)

      @table_view.frame = view_frame
      @form.active_row = @form.active_row

      UIView.commitAnimations
    end
  end
end