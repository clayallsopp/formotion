module Formotion
  module RowType
    class SubformRow < Base

      def build_cell(cell)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end

      def on_select(tableView, tableViewDelegate)
        subform = row.subform.to_form
        row.form.controller.push_subform(subform)
      end

    end
  end
end