module Formation
  class Controller < UIViewController
    attr_accessor :form
    attr_reader :table_view

    def initWithForm(form)
      self.init()
      if form.is_a? Hash
        self.form = Formation::Form.new(form)
      else
        self.form = form
      end
      self
    end

    def loadView
      height = 460
      height -= 44 if self.navigationController
      self.view = UIView.alloc.initWithFrame(CGRectMake(0,20,320,height))
    end

    def viewDidLoad
      super

      self.title = self.form.title

      NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillHideOrShow:', name:UIKeyboardWillHideNotification, object:nil);
      NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillHideOrShow:', name:UIKeyboardWillShowNotification, object:nil);

      @table_view = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStyleGrouped)
      self.view.addSubview @table_view

      @form.sections[-1] && @form.sections[-1].rows[-1].on_enter do |row|
        @form.submit
        row.field.resignFirstResponder
      end
      @form.controller = self
      @form.on_submit do
        p @form.render
      end
    end

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