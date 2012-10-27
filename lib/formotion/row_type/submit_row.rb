module Formotion
  module RowType
    class SubmitRow < ButtonRow

      def on_select(tableView, tableViewDelegate)
        tableViewDelegate.submit
      end

    end
  end
end