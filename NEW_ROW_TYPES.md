# Creating New Row Types

We've tried to make Formotion as extensible as possible so you can create new row types. If you think others could use it, feel free to submit a [pull request](https://github.com/clayallsopp/formotion/pulls).

## Steps

### 1 - Subclass

Add a subclass of `RowType::Base` to the `Formotion::RowType` module and conform your class name to the form `____Row`.

Example:

```ruby
module Formotion
  module RowType
    class MyNewRow < Base
    end
  end
end
```

`RowType.for` looks for classes inside the module with match that name form (see `row_type.rb`). This allows you to refer to your new type in the Formotion hashes as an underscored version of your class name:

```ruby
Formotion::Form.new({
  sections: [{
    rows: [{
      title: "MyNewRow Example",
      type: :my_new
    }]
  }]
})
```

### 2 - Override

The flow of using `RowType` is:

1. `row.make_cell` is called, which calls...
2. `Formotion::RowCellBuilder.make_cell(row)`, which calls...
3. `row.object.build_cell(cell)` **This is where you come in**
4. `YourRowType#build_cell(<#UITableViewCell>)` should setup the cell however you need to.
5. `build_cell` should return an instance of UITextField if necessary. See `StringRow#build_cell` for an example.
6. Lastly, `YourRowType#after_build(#<UITableViewCell>)` is called when the `row` object is entirely setup and right before it's passed back to the table view for drawing.

So the meat of your overrides should happen in **build_cell**.

Ex:

```ruby
module Formotion
  module RowType
    class MyNewRow < Base
      def build_cell(cell)
        blue_box = UIView.alloc.initWithFrame [[10, 10], [30, 30]]
        blue_box.backgroundColor = UIColor.blueColor
        cell.addSubview blue_box

        # return nil because no UITextField added.
        nil
      end
    end
  end
end
```

### 3 - Callbacks And Defaults

Your subclass can override these methods:

`#on_select(tableView, tableViewDelegate)` - Called when the row is tapped by the user.

`#cell_style` - The `UITableViewCellStyle` for the row type. By default is `UITableViewCellStyleSubtitle`
