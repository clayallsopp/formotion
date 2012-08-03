module Formotion
  module RowType
    class CheckRow < Base
      include BW::KVO

      def update_cell_value(cell)
        cell.accessoryType = cell.editingAccessoryType = row.value ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
      end

      # This is actually called whenever again cell is checked/unchecked
      # in the UITableViewDelegate callbacks. So (for now) don't
      # instantiate long-lived objects in them.
      # Maybe that logic should be moved elsewhere?
      def build_cell(cell)
        update_cell_value(cell)
        observe(self.row, "value") do |old_value, new_value|
          update_cell_value(cell)
        end
        nil
      end

      def on_select(tableView, tableViewDelegate)
        if row.section.select_one and !row.value
          row.section.rows.each do |other_row|
            other_row.value = (other_row == row)
          end
        elsif !row.section.select_one
          row.value = !row.value
        end
      end

    end
  end
end