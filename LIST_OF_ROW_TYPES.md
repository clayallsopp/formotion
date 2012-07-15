**Character based**<br/>
[String](#string)<br/>
[Text](#text)<br/>
[Email](#email)<br/>
[Number](#number)<br/>
[Date](#date)

**Other**<br/>
[Static](#static)<br/>
[Switch](#switch)<br/>
[Check](#check)<br/>
[Slider](#slider)<br/>
[Image](#image)

**Buttons**<br/>
[Submit](#submit)

## Character based

### <a name="string"></a> String row
[[https://github.com/clayallsopp/formotion/wiki/row-types/string.png]]
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

### <a name="text"></a> Text row
[[https://github.com/clayallsopp/formotion/wiki/row-types/text.png]]

```ruby
{
  title: "Text",
  key: :text,
  type: :text,
  placeholder: "Enter your text here",
  rowHeight: 100
}
```

### <a name="email"></a> Email row
[[https://github.com/clayallsopp/formotion/wiki/row-types/email.png]]
```ruby
{
  title: "Email",
  key: :email,
  type: :email,
  placeholder: 'me@mail.com'
}
```

### <a name="number"></a> Number row
[[https://github.com/clayallsopp/formotion/wiki/row-types/number.png]]

```ruby
{
  title: "Number",
  key: :number,
  placeholder: "12345",
  type: :number
}
```

### <a name="date"></a> Date row
[[https://github.com/clayallsopp/formotion/wiki/row-types/date.png]]

```ruby
{
  title: "Date",
  value: 326937600,
  key: :date_long,
  type: :date,
  format: :full
}
```

## Other

### <a name="static"></a> Static row
[[https://github.com/clayallsopp/formotion/wiki/row-types/static.png]]
```ruby
{
  title: "Static",
  type: :static,
}
```

### <a name="switch"></a> Switch row
[[https://github.com/clayallsopp/formotion/wiki/row-types/switch.png]]

```ruby
{
  title: "Remember?",
  key: :remember,
  type: :switch,
}
```

### <a name="check"></a> Check row
[[https://github.com/clayallsopp/formotion/wiki/row-types/check.png]]

```ruby
{
  title: "Check",
  key: :check,
  type: :check,
  value: true
}
```

### <a name="slider"></a> Slider row
[[https://github.com/clayallsopp/formotion/wiki/row-types/slider.png]]

```ruby
{
  title: "Slider",
  key: :slider,
  type: :slider,
  range: (1..100),
  value: 25
}
```

### <a name="image"></a> Image row
[[https://github.com/clayallsopp/formotion/wiki/row-types/image.png]]

```ruby
{
  title: "Image",
  key: :image,
  type: :image
}
```

## Buttons

### <a name="submit"></a> Submit row
[[https://github.com/clayallsopp/formotion/wiki/row-types/submit.png]]

```ruby
{
  title: "Submit",
  type: :submit,
}
```