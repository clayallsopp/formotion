motion_require 'object_row'

module Formotion
  module RowType
    class WebLinkRow < ObjectRow

      def after_build(cell)
        super

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        self.row.text_field.hidden = true
      end

      def on_select(tableView, tableViewDelegate)
        if is_url?
          if row.warn.nil? || row.warn == false
            App.open_url row.value
          else
            warn
          end
        else
          raise StandardError, "Row value for WebLinkRow should be a URL string or instance of NSURL."
        end
      end

      def is_url?
        (row.value.is_a?(String) && row.value[0..3] == "http") || row.value.is_a?(NSURL)
      end

      def warn
        row.warn = {} unless row.warn.is_a? Hash #Convert value from true to a hash
        row.warn = {
          title: "Leaving #{App.name}",
          message: "This action will leave #{App.name} and open Safari.",
          buttons: ["Cancel", "OK"]
        }.merge(row.warn)

        BW::UIAlertView.new({
          title: row.warn[:title],
          message: row.warn[:message],
          buttons: row.warn[:buttons],
          cancel_button_index: 0
        }) do |alert|
          App.open_url(row.value) unless alert.clicked_button.cancel?
        end.show
      end

    end
  end
end
