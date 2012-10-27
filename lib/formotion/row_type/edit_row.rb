module Formotion
  module RowType
    class EditRow < ButtonRow
      def on_select(tableView, tableViewDelegate)
        was_editing = tableView.isEditing
        if row.alt_title
          new_title = !was_editing ? row.alt_title : row.title
          tableView.cellForRowAtIndexPath(row.index_path).textLabel.text = new_title
        end
        tableView.setEditing(!was_editing, animated: true)
      end
    end
  end
end