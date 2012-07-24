module Formotion
  module RowType
    class BackRow < Button

      def on_select(tableView, tableViewDelegate)
        tableViewDelegate.pop_subform
      end

    end
  end
end