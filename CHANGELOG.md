## 1.2 - ??

- Added `:picker_mode` row property which lets you choose what type of date picker you're using (i.e. `:date`, `:time`, `:date_time`, or `:countdown`)

### Bug Fixes

- Fixed size issue with iPhone apps running @2x on an iPad (see `row_type/base.rb#field_buffer`)

- Fixed bug in `PickerRow` where KVOing `:value` changes woulnd't reflect in the picker UI.

## 1.1.5 - November 9, 2012

### Features

- Added `form.values = { key: "value" }`, which will set all of the form's `value`s for each specified `key` en-masse.

- `:options` and `:picker` rows support a mapping between the displayed value and the row's value. Ex: `row.items = [["User 1", user1_id], ["User 2", user2_id]]

- `:static` rows are now able to use `:placeholder` and `:value` attributes to display text along the right-hand side.

## 1.1.4 - October 27, 2012

### Features

- Support a generic `:button` `RowType` which can be used in conjunction with a `Row`'s `on_tap` method.

### Bug Fixes

- Fixed bug where pushing a subform inherited from current controller class, which could cause expected behavior.

- Fixed crash when a Slider or Switch row type had an empty :title

- Fixed device crash when taking photo

- Fixed problems related to KVO-ing `Formable` objects.

- Use `UIKeyboardTypeNumberPad` for iPads; `UIKeyboardTypeDecimalPad` doesn't exist for those.

## 1.1.2 - October 6, 2012

### Bug Fixes

- Raise `Formotion::NoRowTypeError` if no `RowType` (`:type`) is specified.

- Fix bug for iOS6 where some fields weren't getting their value set.

## 1.1.1 - September 28, 2012

### Bug Fixes

- Updated to require BubbleWrap 1.1.4 for RM 1.24 compatibility

## 1.1 - September 20, 2012

### Features

- `:display_key` for a `:subform` row; when given, the value for that key in the subform's `#render` will be displayed alongside the chevron:

![Subform row with display](http://i.imgur.com/FoDo1.png)

- `Formotion::Form.persist` and `:persist_as` to automatically synchronize your form to the disk:

```ruby
@form = Formotion::Form.persist({
  persist_as: :settings,
  sections: [....]
})
```

### Bug Fixes

- Fix problems with inheriting Formable models.

## 1.0 - August 11, 2012

### Features

- `:subform` `RowType`. Tapping this row will push a new form with the information given in the row's `subform` property.
- `:template` `RowType`. This type of row allows you to add more "child" rows according to a specification given in the `:template` key.
- `Formotion::Formable` module for to `include` in models. This adds a `.to_form` method and can be used with a `Formotion::FormableController` to automatically create a form synced to a model.

### Improvements

- `reuseIdentifier` is now based on `#object_id`, so dynamically adding rows at runtime should work.
- Every `RowType` now has an appropriate binding between `row.value` and it's display. So if you have a `StringRow` and change it's `row.value` programmatically, the view will update accordingly.
- `rake spec:units` and `rake spec:functionals` for running tests faster.
- renamed `rowHeight` to `row_height`

### Bug Fixes

- Fixed crash when `form.submit` called without a `on_submit` callback set.
- Add more thorough file dependencies

## 0.5.1 - July 19, 2012

### Improvements

- Add new row type for UIPickerView (:picker)

### Bug Fixes

- Bump required bubble-wrap version to 1.1.2 to fix a `lib` path issue.

## 0.5.0 - July 18, 2012

### Improvements

- Add new row type for images (:image)
- Add new row type for UISegmentedControl (:options)
- Add new row type for UISlider (:slider)
- Add new row type for multiline text (:text)
- Add new row types for dates (:date)
- Big code refactoring