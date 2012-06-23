class FormController < Formation::Controller
  def self.open(form)
    Routable::Router.router.open("form/#{BubbleWrap::JSON.generate(form.to_hash)}")
  end

  def initWithParams(params = {})
    initWithForm(BubbleWrap::JSON.parse(params[:json]))
  end

  def viewDidLoad
    super

    self.save_button
  end

  def save_button
    self.navigationItem.rightBarButtonItem ||= UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'save')
  end

  def save
    @form.submit

    self.save_button.enabled = false

    @imgView = UIView.alloc.init
    self.view.addSubview(@imgView)

    # RESET TABLE...
    UIView.transitionWithView(self.view,
        duration: 1,
         options: UIViewAnimationOptionTransitionCurlUp,
      animations: lambda { },
      completion: lambda { |finished|
        p "HELLO???"
        @imgView.removeFromSuperview
        self.save_button.enabled = true
      })
  end
end