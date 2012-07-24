module Formotion
  module RowType
    class Base
      attr_accessor :row, :tableView

      def tableView
        @tableView ||= self.row.form.table
      end

      def initialize(row)
        @row = row
      end

      def submit_button?
        false
      end

      # RowCellBuilder uses this to instantiate the UITableViewCell.
      def cell_style
        UITableViewCellStyleSubtitle
      end

      # builder method for row cell specific implementation
      def build_cell(cell)
        # implement in row class
        nil
      end

      # called by the Row after all the setup and connections are made
      # in #make_cell
      def after_build(cell)
      end

      # method gets triggered when tableView(tableView, didSelectRowAtIndexPath:indexPath)
      # in UITableViewDelegate is executed
      def on_select(tableView, tableViewDelegate)
        # implement in row class
      end

      def break_with_semaphore(&block)
        return if @semaphore
        with_semaphore(&block)
      end

      def with_semaphore(&block)
        @semaphore = true
        block.call
        @semaphore = false
      end
    end
  end
end