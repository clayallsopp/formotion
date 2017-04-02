# Formotion

[![Build Status](https://travis-ci.org/clayallsopp/formotion.png)](https://travis-ci.org/clayallsopp/formotion)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=clayallsopp/formotion)](http://clayallsopp.github.io/readme-score?url=clayallsopp/formotion)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Fclayallsopp%2Fformotion.svg?size=small)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Fclayallsopp%2Fformotion?ref=badge_small)

Make this:

![Complex data form](http://i.imgur.com/TMwXI.png)

using this:

```ruby
@form = Formotion::Form.new({
  sections: [{
    title: "Register",
    rows: [{
      title: "Email",
      key: :email,
      placeholder: "me@mail.com",
      type: :email,
      auto_correction: :no,
      auto_capitalization: :none
    }, {
      title: "Password",
      key: :password,
      placeholder: "required",
      type: :string,
      secure: true
    }, {
      title: "Password",
      subtitle: "Confirmation",
      key: :confirm,
      placeholder: "required",
      type: :string,
      secure: true
    }, {
      title: "Remember?",
      key: :remember,
      type: :switch,
    }]
  }, {
    title: "Account Type",
    key: :account_type,
    select_one: true,
    rows: [{
      title: "Free",
      key: :free,
      type: :check,
    }, {
      title: "Basic",
      value: true,
      key: :basic,
      type: :check,
    }, {
      title: "Pro",
      key: :pro,
      type: :check,
    }]
  }, {
    rows: [{
      title: "Sign Up",
      type: :submit,
    }]
  }]
})

@form_controller = Formotion::FormController.alloc.initWithForm(@form)
@window.rootViewController = @form_controller
```

And after the user enters some data, do this:

```ruby
@form.render
=> {:email=>"me@email.com", :password=>"password", 
    :confirm=>"password", :remember=>true, :account_type=>:pro}
```

## Installation

`gem install formotion`

In your `Rakefile`:

`require 'formotion'`

## Usage

### Initialize

You can initialize a `Formotion::Form` using either a hash (as above) or the DSL:

```ruby
form = Formotion::Form.new

form.build_section do |section|
  section.title = "Title"

  section.build_row do |row|
    row.title = "Label"
    row.subtitle = "Placeholder"
    row.type = :string
  end
end
```

Then attach it to a `Formotion::FormController` and you're ready to rock and roll:

```ruby
@controller = Formotion::FormController.alloc.initWithForm(form)
self.navigationController.pushViewController(@controller, animated: true)
```

### Data Types

See [the visual list of support row types](https://github.com/clayallsopp/formotion/blob/master/LIST_OF_ROW_TYPES.md).

To add your own, check [the guide to adding new row types](https://github.com/clayallsopp/formotion/blob/master/NEW_ROW_TYPES.md).

`Formotion::Form`, `Formotion::Section`, and `Formotion::Row` all respond to a `::PROPERTIES` attribute. These are settable as an attribute (ie `section.title = 'title'`) or in the initialization hash (ie `{sections: [{title: 'title', ...}]}`). Check the comments in the 3 main files (`form.rb`, `section.rb`, and `row.rb` for details on what these do).

### Setting Initial Values

Forms, particularly edit forms, have default initial values. You can supply these in the `:value` attribute for a given row. So, for example:

```ruby
{
  title: "Email",
  key: :email,
  placeholder: "me@mail.com",
  type: :email,
  auto_correction: :no,
  auto_capitalization: :none,
  value: 'zippity_dippity@doo.com'
}
```

Setting values for non-string types can be tricky, so you need to watch what the particular field expects. In particular, date types require
the number of seconds from the beginning of the epoch as a number.

### Retrieve

You have `form#submit`, `form#on_submit`, and `form#render` at your disposal. Here's an example:

```ruby
class PeopleController < Formotion::FormController
  def viewDidLoad
    super

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'submit')
  end

  def submit
    data = self.form.render

    person.name = data[:name]
    person.address = data[:address]
  end
end
```

Why would you use `form#on_submit`? In case you want to use `type: :submit`. Ex:

```ruby
@form = Formotion::Form.new({
  sections: [{
  ...
  }, {
    rows: [{
      title: "Save",
      type: :submit
    }]
  }]
})

@form.on_submit do |form|
  # do something with form.render
end
```

`form#submit` just triggers `form#on_submit`.

### Persistence

You can easily synchronize a `Form`'s state to disk using the `persist_as` key in form properties. When your user edits the form, any changes will be immediately saved. For example:

```ruby
@form = Formotion::Form.new({
  persist_as: :settings,
  sections: ...
})
```

This will load the form if it exists, or create it if necessary. If you use remove the `persist_as` key, then the form will not be loaded and any changes you make will override existing saved forms.

Your form values and state are automatically persisted across application loads, no save buttons needed.

To reset the form, call `reset`, which restores it to the original state.

View the [Persistence Example](./examples/Persistence) to see it in action.

### Callbacks

`Row` objects support the following callbacks:

```ruby
row.on_tap do |row|
  p "I'm tapped!"
end

row.on_delete do |row|
  p "I'm called before the delete animation"
end

row.on_begin do |row|
  p "I'm called when my text field begins editing"
end

row.on_enter do |row|
  p "I'm called when the user taps the return key while typing in my text field"
end
```
     
## Forking

Feel free to fork and submit pull requests! And if you end up using Formotion in your app, I'd love to hear about your experience.

## License

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Fclayallsopp%2Fformotion.svg?size=large)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2Fclayallsopp%2Fformotion?ref=badge_large)

## Todo

- Not very efficient right now (creates a unique reuse idenitifer for each cell)
- Styling/overriding the form for custom UITableViewDelegate/Data Source behaviors.
