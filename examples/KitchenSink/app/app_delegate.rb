class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @form = Formotion::Form.new({
      title: "Kitchen Sink",
      sections: [{
        title: "Section Title",
        footer: "This is the footer for the section. It's good for displaying detailed data about the section.",
        rows: [{
          title: "Static",
          type: :static,
        }, {
          title: "Email",
          key: :email,
          placeholder: "me@mail.com",
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Gender",
          key: :gender,
          type: :control,
          items: ['Female', 'Male']
        }, {
          title: "Password",
          key: :password,
          placeholder: "required",
          type: :string,
          secure: true
        }, {
          title: "Phone",
          key: :phone,
          placeholder: "555-555-5555",
          type: :phone,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Number",
          key: :number,
          placeholder: "12345",
          type: :number,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Subtitle",
          subtitle: "Confirmation",
          key: :confirm,
          placeholder: "required",
          type: :string,
          secure: true
        }, {
          title: "Row Height",
          key: :row_height,
          placeholder: "60px",
          type: :string,
          rowHeight: 60
        }, {
          title: "Text",
          key: :text,
          type: :text,
          placeholder: "Enter your text here",
          rowHeight: 100
        }, {
          title: "Check",
          key: :check,
          type: :check,
          value: true
        }, {
          title: "Remember?",
          key: :remember,
          type: :switch,
        }, {
          title: "Date Full",
          subtitle: "w/ :value",
          value: 326937600,
          key: :date_long,
          type: :date,
          format: :full
        }, {
          title: "Date Medium",
          subtitle: "w/ :value",
          value: 1341273600,
          key: :date_medium,
          type: :date,
          format: :medium
        }, {
          title: "Date Short",
          subtitle: "w/ :placeholder",
          placeholder: "DOB",
          key: :date_short,
          type: :date,
          format: :short
        }, {
          title: "Slider",
          key: :slider,
          type: :slider,
          range: (1..100),
          value: 25
        }]
      }, {
        title: "Select One",
        key: :account_type,
        select_one: true,
        rows: [{
          title: "A",
          key: :a,
          type: :check,
        }, {
          title: "B (value: true)",
          value: true,
          key: :b,
          type: :check,
        }, {
          title: "C",
          key: :c,
          type: :check,
        }]
      }, {
        rows: [{
          title: "Submit",
          type: :submit,
        }]
      }]
    })

    @navigation_controller = UINavigationController.alloc.init

    @view_controller = Formotion::FormController.alloc.initWithForm(@form)
    @view_controller.form.on_submit do |form|
      form.active_row && form.active_row.text_field.resignFirstResponder
      alert = UIAlertView.alloc.init
      alert.title = "@form.render"
      alert.message = @form.render.to_s
      alert.addButtonWithTitle("OK")
      alert.show
    end

    @view_controller.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'submit')

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@view_controller)

    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible

    true
  end

  def submit
    @form.submit
  end
end
