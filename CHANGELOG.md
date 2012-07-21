## 0.5.2 - ???

### Improvements

- `reuseIdentifier` is now based on `#object_id`, so dynamically adding rows at runtime should work.

### Bug Fixes

- Fixed crash when `form.submit` called without a `on_submit` callback set.

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