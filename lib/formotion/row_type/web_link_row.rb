module Formotion
  module RowType
    class WebLinkRow < ObjectRow

      def after_build(cell)
        super

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        self.row.text_field.hidden = true
        row.value = {url: row.value} unless row.value.is_a?(Hash)
        row.value = {
          warn: false
        }.merge(row.value)
      end

      def on_select(tableView, tableViewDelegate)
        if is_url?
          if row.value[:warn] == false
            App.open_url row.value[:url]
          else
            warn
          end
        end
      end

      def is_url?
        (row.value[:url].is_a?(String) && row.value[:url][0..3] == "http") || row.value[:url].is_a?(NSURL)
      end

      def warn
        row.value[:warn] = {} unless row.value[:warn].is_a? Hash #Convert value from true to a hash
        row.value[:warn] = {
          title: "Leaving #{App.name}",
          message: "This action will leave #{App.name} and open Safari.",
          buttons: ["Cancel", "OK"]
        }.merge(row.value[:warn])

        BW::UIAlertView.new({
          title: row.value[:warn][:title],
          message: row.value[:warn][:message],
          buttons: row.value[:warn][:buttons],
          cancel_button_index: 0
        }) do |alert|
          App.open_url(row.value[:url]) unless alert.clicked_button.cancel?
        end.show
      end

    end
  end
end
