# Formotion

Make this:

![Complex data form][]

using just this:

```ruby
form = Formation::Form.new({
  sections: [{
    title: "Register",
    rows: [{
      title: "Email",
      placeholder: "me@mail.com",
      type: Formation::RowType::EMAIL,
      editable: true,
      auto_correction:  UITextAutocorrectionTypeNo,
      auto_capitalization: UITextAutocapitalizationTypeNone
    }, {
      title: "Password",
      placeholder: "required",
      type: Formation::RowType::STRING,
      editable: true,
      secure: true
    }, {
      title: "Confirm",
      placeholder: "required",
      type: Formation::RowType::STRING,
      editable: true,
      secure: true
    }]
  }, {
    select_one: true,
    rows: [{
      title: "Remember?",
      switchable: true,
    }]
  }, {
    title: "Account Type",
    select_one: true,
    rows: [{
      title: "Free",
      checkable: true,
    }, {
      title: "Basic",
      checkable: true,
    }, {
      title: "Pro",
      checkable: true,
    }]
  }]
})

@form_controller = FormController.alloc.initWithForm(form)
@window.rootViewController = @form_controller
```

## Installation

`gem install formotion`

In your `Rakefile`:

`require 'formotion'`

## Usage

### Initialize

You can initialize a `Formotion::Form` using either a hash (as above) or the DSL:

```ruby
form = Formation::Form.new

form.build_section do |section|
  section.title = "Title"

  section.build_row do |row|
    row.title = "Label"
    row.subtitle = "Placeholder"
  end
end
```

Then attach it to a `Formotion::Controller` and you're ready to rock and roll:

```ruby
@controller = Formation::Controller.alloc.initWithForm(form)
self.navigationController.pushViewController(@controller, animated: true)
```

### Retreive

You have `form#submit`, `form#on_submit`, and `form#render` at your disposal. Here's an example:

```ruby
class PeopleController < Formotion::Controller
  def viewDidLoad
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'submit')
  end

  def submit
    data = self.form.render

    person.name = data[:name]
    person.address = data[:address]
  end
end
```

Why would you use `form#on_submit`? In case you want to use `Formation::RowType::SUBMIT`. Ex:

```ruby
@form = Formotion::Form.new({
  sections: [{
  ...
  }, {
    rows: [{
      title: "Save",
      type: Formation::RowType::SUBMIT
    }]
  }]
})

@form.on_submit do |form|
  # do something with form.render
end
```

`form#submit` just triggers `form#on_submit`.

### Data Types

`Formotion::Form`, `Formotion::Section`, and `Formotion::Row` all respond to a `::PROPERTIES` attribute. These are settable as a property (ie `section.title = 'title'`) or in the initialization hash (ie `{sections: [{title: 'title', ...}]}`).

