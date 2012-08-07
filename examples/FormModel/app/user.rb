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