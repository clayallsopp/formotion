**Character based**<br/>
[String](#string)<br/>
[Text](#text)<br/>
[Email](#email)<br/>
[Phone](#phone)<br/>
[Number](#number)<br/>
[Date](#date)

**Other**<br/>
[Static](#static)<br/>
[Switch](#switch)<br/>
[Check](#check)<br/>
[Slider](#slider)<br/>
[Image](#image)<br/>
[Option](#option)<br/>
[Picker](#picker)<br/>
[Subform](#subform)<br/>
[Template](#template)

**Buttons**<br/>
[Button](#button)<br/>
[Submit](#submit)<br/>
[Back](#back)<br/>
[Edit](#edit)<br/>

## General

All row types accept following properties:
```ruby
{
  key:        :user_name,     # Unique identifier for the row
  value:      'Some Value',   # The initial value passed to the row
  title:      'Title',        # Title of the row
  subtitle:   'Subtitle',     # Subtitle of the row
  type:       :string,        # The type of row (string, phone, switch, etc)
  row_height: 100             # Height of the row
}
```

The `type` property will define what kind of row type will get built. It looks for any Class within the `Formotion::RowType` namespace that has the constantized name (e.g. Formotion::RowType::StringRow).


## Character based

All character based row types accept following properties:
```ruby
{
  placeholder:         'James Bond',     # Placeholder before a value exists
  auto_correction:     :no,              # Disable auto correction
  auto_capitalization: :none,            # Disable auto capitalization
  secure:              true,             # Enable secure input (Password)
  clear_button:        :while_editing,   # Enable clear button
  return_key:          :google,          # Define return key
}
```

### <a name="string"></a> String row

![String row](https://github.com/clayallsopp/formotion/wiki/row-types/string.png)
```ruby
{
  title: "Name",
  key: :name,
  type: :string,
  placeholder: 'James Bond',
  auto_correction: :no,
  auto_capitalization: :none
}
```

The `StringRow` is a simple text input row and opens a `UIKeyboardTypeDefault` keyboard when editing.


### <a name="text"></a> Text row
![Text Row](https://github.com/clayallsopp/formotion/wiki/row-types/text.png)

```ruby
{
  title: "Text",
  key: :text,
  type: :text,
  placeholder: "Enter your text here",
  row_height: 100
}
```

The `TextRow` is a multiline text input row and opens the default keyboard when editing.
To define the height of the row set the property `row_height`.


### <a name="email"></a> Email row
![Email row](https://github.com/clayallsopp/formotion/wiki/row-types/email.png)
```ruby
{
  title: "Email",
  key: :email,
  type: :email,
  placeholder: 'me@mail.com'
}
```

The `EmailRow` is a string input row for an email address and opens a `UIKeyboardTypeEmailAddress` keyboard when editing.


### <a name="phone"></a> Phone row
![Email row](https://github.com/clayallsopp/formotion/wiki/row-types/phone.png)
```ruby
{
  title: "Phone",
  key: :phone,
  type: :phone,
  placeholder: '+01 877 412 7753'
}
```

The `PhoneRow` is a string input row for a phone number and opens a `UIKeyboardTypePhonePad` keyboard when editing.


### <a name="number"></a> Number row
![Number row](https://github.com/clayallsopp/formotion/wiki/row-types/number.png)

```ruby
{
  title: "Number",
  key: :number,
  placeholder: "12345",
  type: :number
}
```

The `NumberRow` is a string input row for a number and opens a `UIKeyboardTypeDecimalPad` keyboard when editing.


### <a name="date"></a> Date row
![Date row](https://github.com/clayallsopp/formotion/wiki/row-types/date.png)

```ruby
{
  title: "Date",
  value: 326937600,
  key: :date_long,
  type: :date,
  format: :full
}
```

The `DateRow` is a string input row for a date and opens a `UIDatePicker` when editing.
You can pass one of following formats as property:
```ruby
  :no       # NSDateFormatterNoStyle - Specifies no style.
  :short    # NSDateFormatterShortStyle - Specifies a short style, typically numeric only, such as “11/23/37” or “3:30pm”.
  :medium   # NSDateFormatterMediumStyle - Specifies a medium style, typically with abbreviated text, such as “Nov 23, 1937”.
  :long     # NSDateFormatterLongStyle - Specifies a long style, typically with full text, such as “November 23, 1937” or “3:30:32pm”.
  :full     # NSDateFormatterFullStyle -Specifies a full style with complete details, such as “Tuesday, April 12, 1952 AD” or “3:30:42pm PST”.
```

The `value` is a `NSDate.timeIntervalSince1970` as an integer.


## Other

### <a name="static"></a> Static row
![Static row](https://github.com/clayallsopp/formotion/wiki/row-types/static.png)
```ruby
{
  title: "Static",
  type: :static,
}
```

The `StaticRow` has no input funcitonality and therefore needs no `key` property. It is used for static text display like in Settings > General > About on your iOS device.


### <a name="switch"></a> Switch row
![Switch row](https://github.com/clayallsopp/formotion/wiki/row-types/switch.png)

```ruby
{
  title: "Remember?",
  key: :remember,
  type: :switch,
}
```

The `SwitchRow` is a on/off switch that has the `value` true or false.


### <a name="check"></a> Check row
![Check row](https://github.com/clayallsopp/formotion/wiki/row-types/check.png)

```ruby
{
  title: "Check",
  key: :check,
  type: :check,
  value: true
}
```

The `CheckRow` is a row you can check and uncheck by tapping on it. It has either the `value` true or false.
You can create a radio button style group by defining a section with `select_one: true` like this:

```ruby
{
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
}
```


### <a name="slider"></a> Slider row
![Slider row](https://github.com/clayallsopp/formotion/wiki/row-types/slider.png)

```ruby
{
  title: "Slider",
  key: :slider,
  type: :slider,
  range: (1..100),
  value: 25
}
```

The `SliderRow` takes a ruby range as `range` property that defines the min and max value of the slider.

### <a name="image"></a> Image row
![Image row](https://github.com/clayallsopp/formotion/wiki/row-types/image.png)

```ruby
{
  title: "Image",
  key: :image,
  type: :image
}
```

### <a name="options"></a> Options row
![Options row](https://github.com/clayallsopp/formotion/wiki/row-types/options.png)

```ruby
{
  title: "Account Type",
  key: :account_type,
  type: :options,
  items: ["Free", "Basic", "Pro"]
}
```


### <a name="picker"></a> Picker row
![Picker row](https://github.com/clayallsopp/formotion/wiki/row-types/picker.png)

```ruby
{
  title: "Picker",
  key: :pick,
  type: :picker,
  items: ["Ruby", "Motion", "Rocks"],
  value: "Motion"
}
```


### <a name="subform"></a> Subform row
![Subform row](https://github.com/clayallsopp/formotion/wiki/row-types/subform.gif)

```ruby
{
  title: "Advanced",
  type: :subform,
  key: :advanced,
  subform: {
    title: "Advanced",
    sections: [{
      title: "Advanced Settings",
      rows: [{
        title: "Server URL",
        key: :server,
        placeholder: "example.com",
        type: :string,
      }]
    }, {
      rows: [{
        title: 'Back',
        type: :back
      }]
    }]
  }
}
```

Use a `:display_key` to show the value of the subform in the row:

![Subform row with display](http://i.imgur.com/FoDo1.png)

```ruby
{
  title: "Subform",
  subtitle: "With display_key",
  type: :subform,
  display_key: :type,
  subform: {
    ...
  }
}
```

### <a name="template"></a> Template row
![Template row](https://github.com/clayallsopp/formotion/wiki/row-types/template.gif)

```ruby
{
  title: 'Your nicknames',
  rows: [{
    title: "Add nickname",
    key: :nicknames,
    type: :template,
    value: ['Nici', 'Sam'],
    template: {
      title: 'Nickname',
      type: :string,
      placeholder: 'Enter here',
      indented: true,
      deletable: true
    }
  }]
}
```

## Buttons

### <a name="button"></a> Button row

```ruby
{
  title: "Any Button",
  type: :button,
}

# later...
form.sections[0].rows[0].on_tap do |row|
  # do something when tapped
end
```

The `SubmitRow` triggers the `form.submit` which triggers the defined `on_submit` callback.

### <a name="submit"></a> Submit row
![Submit row](https://github.com/clayallsopp/formotion/wiki/row-types/submit.png)

```ruby
{
  title: "Submit",
  type: :submit,
}
```

The `SubmitRow` triggers the `form.submit` which triggers the defined `on_submit` callback.


### <a name="back"></a> Back row
![Submit row](https://github.com/clayallsopp/formotion/wiki/row-types/back.png)

```ruby
{
  title: "Back",
  type: :back,
}
```

The `BackRow` is used in subforms to go back to the parent form.


### <a name="edit"></a> Edit row
![Submit row](https://github.com/clayallsopp/formotion/wiki/row-types/edit.png)

```ruby
{
  title: "Edit",
  alt_title: "View",
  type: :edit,
}
```

The `EditRow` is used to switch between edit and view mode. It's mainly used for the `TemplateRow`.