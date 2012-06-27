module Formotion
  module RowType
    class Base
      attr_accessor :row

      def initialize(row)
        @row = row
      end

      def submit_button?
        false
      end

      # builder method for row cell specific implementation
      def build_cell(cell)
        # implement in row class
        nil
      end

      # method gets triggered when tableView(tableView, didSelectRowAtIndexPath:indexPath)
      # in UITableViewDelegate is executed
      def on_select(tableView, tableViewDelegate)
        # implement in row class
      end

    end
  end
end