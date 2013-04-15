motion_require 'base'

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
      include BubbleWrap::KVO

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
        new_row = build_new_row
        move_row_in_list(new_row)
        insert_row(new_row)
      end

      def build_new_row(options = {})
        # build row
        new_row = row.section.create_row(row.template.merge(options))
        new_row.object.instance_eval do
          def after_delete
            template_value = row.template_parent.value
            template_value.delete_at(row.index)
            row.template_parent.value = template_value
            row.template_parent.template_children.delete_at(row.index)
          end
        end
        new_row.remove_on_delete = true
        new_row.template_parent = row
        row.template_children ||= []
        row.template_children << new_row
        observe(new_row, "value") do |old_value, new_value|
          template_value = row.value.dup
          template_value[new_row.index] = new_row.value
          row.value = template_value
        end
        new_row
      end

      def move_row_in_list(new_row)
        # move to top
        row.section.rows.pop
        row.section.rows.insert(row.template_children.count - 1, new_row)

        # reset indexes
        row.section.refresh_row_indexes
      end

      def insert_row(template_row, with_animation = true)
        animation = with_animation ? UITableViewRowAnimationBottom : UITableViewRowAnimationNone
        index_path = NSIndexPath.indexPathForRow(template_row.index, inSection:row.section.index)
        tableView.beginUpdates
        tableView.insertRowsAtIndexPaths [index_path], withRowAnimation:animation
        tableView.endUpdates
      end

      def delete_row(template_row, with_animation = true)
        animation = with_animation ? UITableViewRowAnimationTop : UITableViewRowAnimationNone
        index_path = NSIndexPath.indexPathForRow(template_row.index, inSection:row.section.index)
        tableView.beginUpdates
        tableView.deleteRowsAtIndexPaths [index_path], withRowAnimation:animation
        tableView.endUpdates
      end

      def update_template_rows
        row.value ||= []
        if row.value.count > row.template_children.count
          row.value[row.template_children.count..-1].each do |value|
            new_row = build_new_row({:value => value})
            move_row_in_list(new_row)
            insert_row(new_row) if tableView
          end
        elsif row.value.count < row.template_children.count
          row.template_children[row.value.count..-1].each do |row_to_delete|
            row.section.rows.delete(row_to_delete)
            row.template_children.delete(row_to_delete)
            row.section.refresh_row_indexes
            delete_row(row_to_delete) if tableView
          end
        end

        row.value.dup.each_with_index do |new_value, index|
          template_child = row.template_children[index]
          old_value = template_child.value
          if old_value != new_value
            template_child.value = new_value
          end
        end
      end

    end
  end
end