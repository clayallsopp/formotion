module Formotion
  module RowType
    class SubformRow < Base

      def build_cell(cell)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end

      def on_select(tableView, tableViewDelegate)
        tableViewDelegate.push_subform(row.subform)
      end

    end
  end
end