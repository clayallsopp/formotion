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

class ObserverTest
  include BubbleWrap::KVO

  def users
    @users ||= [User.new("Harry", 100, "Green"),
                User.new("Ron", 80, "Blue"),
                User.new("Hermione", 120, "Red")]
  end

  def start_observing
    observe(self.users.first, "team") do |old_value, new_value|
    end
  end
end

describe "Formotion::Formable w/ KVO" do
  it "should work" do
    test = ObserverTest.new
    test.start_observing

    test.users[0].to_form.title.should == test.users[1].to_form.title
    test.users[0].class.form_properties.should == test.users[1].class.form_properties

    test.unobserve_all
  end
end