# Define template row:
# {
#   title: "Add nickname",
#   key: :nicknames,
#   type: :template,
#   template: {
#     title: 'Nickname %{index}',
#     type: :string
#   }
#   value: ['Samy', 'Pamy']
# }

# row.value = ['Samy', 'Pamy']
module Formotion
  module RowType
    class TemplateRow < Base

      def cellEditingStyle
        UITableViewCellEditingStyleInsert
      end

      def indentWhileEditing?
        true
      end

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleBlue
        @add_button ||= begin
          button = UIButton.buttonWithType(UIButtonTypeContactAdd)
          button.when(UIControlEventTouchUpInside) do
            self.on_select(nil, nil)
          end
          button
        end
        cell.accessoryView = @add_button

        nil
      end

      def on_select(tableView, tableViewDelegate)
        on_insert(tableView, tableViewDelegate)
      end

      def on_insert(tableView, tableViewDelegate)
        @template_index = row.section.rows.count
        new_row = build_new_row
        move_row_in_list(new_row)
        insert_row(new_row)
      end

      def build_new_row(options = {})
        # build row
        new_row = row.section.create_row(row.template.merge(options))
        new_row.remove_on_delete = true
        new_row.template_parent = self.row
        new_row
      end

      def move_row_in_list(new_row)
        # move to top
        row.section.rows.pop
        row.section.rows.insert(@template_index - 1, new_row)

        # reset indexes
        row.section.refresh_row_indexes
      end

      def insert_row(new_row)
        index_path = NSIndexPath.indexPathForRow(new_row.index, inSection:row.section.index)
        tableView.beginUpdates
        tableView.insertRowsAtIndexPaths [index_path], withRowAnimation:UITableViewRowAnimationBottom
        tableView.endUpdates
      end

    end
  end
end