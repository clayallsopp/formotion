module Formotion
  module RowType
    class Base
      attr_accessor :row, :tableView

      def self.field_buffer
        if Device.iphone? or App.window.size.width <= 320
          20
        else
          64
        end
      end

      def tableView
        @tableView ||= self.row.form.table
      end

      def initialize(row)
        @row = row
      end

      def button?
        false
      end

      # RowCellBuilder uses this to instantiate the UITableViewCell.
      def cell_style
        UITableViewCellStyleSubtitle
      end

      # Sets the UITableViewCellEditingStyle
      def cellEditingStyle
        row.deletable? ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone
      end

      # Indents row while editing
      def indentWhileEditing?
        row.indented?
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

      # Called on every tableView:cellForRowAtIndexPath:
      # so keep implementation details minimal
      def update_cell(cell)
      end

      # method gets triggered when tableView(tableView, didSelectRowAtIndexPath:indexPath)
      # in UITableViewDelegate is executed
      def on_select(tableView, tableViewDelegate)
        # implement in row class
      end

      # called when the delete editing style was triggered tableView:commitEditingStyle:forRowAtIndexPath:
      def on_delete(tableView, tableViewDelegate)
        if row.remove_on_delete?
          row.section.rows.delete_at(row.index)
          row.section.refresh_row_indexes
          delete_row
        else
          row.value = nil
          self.tableView.reloadData
        end
      end

      def delete_row
        tableView.beginUpdates
        tableView.deleteRowsAtIndexPaths [row.index_path], withRowAnimation:UITableViewRowAnimationBottom
        tableView.endUpdates
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