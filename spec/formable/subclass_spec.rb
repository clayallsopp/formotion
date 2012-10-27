class User
  include Formotion::Formable

  attr_accessor :name, :score, :team

  form_property :name, :string
  form_property :score, :number, transform: lambda { |value| value.to_i }

  form_property :team, :picker, items: ["Red", "Blue", "Green"]

  form_title "Edit User"

  def initialize(name, score, team)
    self.name = name
    self.score = score
    self.team = team
  end
end

class AwesomeUser < User
end

describe "Formotion::Formable w/ Subclasses" do
  it "should work" do
    user = User.new("Harry", 100, "Green")
    awesome = AwesomeUser.new("Clay", 200, "Red")

    user.to_form.title.should == awesome.to_form.title
    user.class.form_properties.should == awesome.class.form_properties
  end
end