## 1.8.1 - September 14, 2016

### Bug Fixes

- Fixed a bug in `picker_row` where the value of picker wasn't being set in `didSelectRow`.

## 1.3.1 - April 15, 2013

### Features

- Added `:input_accessory` property, which currently accepts `:done` as the value. This will add a `UIToolbar` above the keyboard with a "Done" button the user can tap to dismiss the keyboard.

- Added `Row#on_delete` callback which occurs when a row is swipe-to-delete'd.

### Bug Fixes

-  `:image` rows which are not editable do not show the "plus" icon.

- Fixed bugs in `:template` rows (see [#100](https://github.com/clayallsopp/formotion/issues/100) and [#101](https://github.com/clayallsopp/formotion/pull/101)).

## 1.3 - March 25, 2013

### Features

- Added `:currency` row type, which automatically presents an entered number into the current locale's format (i.e. "$4,003.45" or "€ 3.004,35")

- Added `on_delete` callback for when a `Row` is deleted

- Correctly handle `on_tap` for `Row` objects, regardless of whether or not they are `:button`s.

### Bug Fixes

- Fixed a crash that occured when rapidly serializing a form.

- Template rows are now persisted correctly.

- `ImageRow`s which are disabled will not show the "plus" icon

## 1.2 - January 3, 2013

### Features

- Added `:picker_mode` row property which lets you choose what type of date picker you're using (i.e. `:date`, `:time`, `:date_time`, or `:countdown`)

- Added `:text_alignment` row property which controls how a row's input field's text is aligned (i.e. `:right` (default), `:left`, or `:center`).

- Added `:editable` row property which controls if a user can interact with the row's control (a text input, slider, etc)

### Bug Fixes

- Fixed size issue with iPhone apps running @2x on an iPad (see `row_type/base.rb#field_buffer`)

- Fixed bug in `PickerRow` where KVOing `:value` changes woulnd't reflect in the picker UI.

- Fixed bug in a `UITextView` patch that removed copy and paste by default for all `UITextView`s.

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