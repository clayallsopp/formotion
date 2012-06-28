module Formotion
  module RowType
    class CheckRow < Base

      # This is actually called whenever again cell is checked/unchecked
      # in the UITableViewDelegate callbacks. So (for now) don't
      # instantiate long-lived objects in them.
      # Maybe that logic should be moved elsewhere?
      def build_cell(cell)
        cell.accessoryType = row.value ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
        nil
      end

      def on_select(tableView, tableViewDelegate)
        if row.section.select_one and !row.value
          row.section.rows.each do |other_row|
            other_row.value = (other_row == row)

            cell = tableView.cellForRowAtIndexPath(other_row.index_path)
            other_row.object.build_cell(cell) if cell
          end
        elsif !row.section.select_one
          row.value = !row.value
          build_cell(tableView.cellForRowAtIndexPath(row.index_path))
        end
      end

    end
  end
end