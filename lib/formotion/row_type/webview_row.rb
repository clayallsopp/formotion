motion_require 'base'

module Formotion
  module RowType
    class WebviewRow < Base

      include BW::KVO

      WEB_VIEW_TAG=1100

      def build_cell(cell)
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleBlue

        @web_view = UIWebView.alloc.init
        @web_view.loadHTMLString(row.value, baseURL:nil) if row.value
        @web_view.tag = WEB_VIEW_TAG
        @web_view.contentMode = UIViewContentModeScaleAspectFit
        @web_view.backgroundColor = UIColor.clearColor
        cell.addSubview(@web_view)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(WEB_VIEW_TAG)

            field_frame = formotion_field.frame
            field_frame.origin.y = 10
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            field_frame.size.height = self.frame.size.height - Formotion::RowType::Base.field_buffer
            formotion_field.frame = field_frame
          end
        end
      end

      def on_select(tableView, tableViewDelegate)
        if !row.editable?
          return
        end
      end

    end
  end
end
