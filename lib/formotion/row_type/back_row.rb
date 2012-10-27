module Formotion
  module RowType
    class BackRow < ButtonRow

      def on_select(tableView, tableViewDelegate)
        row.form.controller.pop_subform
      end

    end
  end
end