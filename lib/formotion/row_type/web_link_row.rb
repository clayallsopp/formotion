module Formotion
  module RowType
    class WebLinkRow < StaticRow

      def after_build(cell)
        super

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        self.row.text_field.hidden = true
      end

      def on_select(tableView, tableViewDelegate)
        if row.value.is_a?(String) && row.value[0..3] == "http"
          App.open_url row.value
        end
      end

    end
  end
end
