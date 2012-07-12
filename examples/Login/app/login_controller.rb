class LoginController < Formotion::FormController
  def init
    form = Formotion::Form.new({
      title: "Login",
      sections: [{
        rows: [{
          title: "User Name",
          type: :string,
          placeholder: "name",
          key: :user
        }, {
          title: "Password",
          type: :string,
          placeholder: "password",
          key: :password,
          secure: true
        }, {
          title: "Remember?",
          type: :switch,
          key: :remember,
          value: true
        }]
      }, {
        rows: [{
          title: "Login",
          type: :submit,
        }]
      }]
    })
    form.on_submit do
      self.login
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Login", style: UIBarButtonItemStyleDone, target:self, action:'login')
  end

  def login
    [:user, :password, :remember].each { |prop|
      UserController.controller.send(prop.to_s + "=", form.render[prop])
    }
    self.navigationController.dismissModalViewControllerAnimated(true)
  end
end