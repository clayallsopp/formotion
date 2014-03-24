motion_require 'base'

module Formotion
  module RowType
    class SubformRow < Base

      LABEL_TAG=1001

      def build_cell(cell)
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleBlue
        cell.accessoryType = cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator

        cell.contentView.addSubview(self.display_key_label)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            formotion_label = self.viewWithTag(LABEL_TAG)
            formotion_label.sizeToFit

            field_frame = formotion_label.frame
            # HARDCODED CONSTANT
            field_frame.origin.x = self.contentView.frame.size.width - field_frame.size.width - 10
            field_frame.origin.y = ((self.contentView.frame.size.height - field_frame.size.height) / 2.0).round
            formotion_label.frame = field_frame
          end
        end

        display_key_label.highlightedTextColor = cell.textLabel.highlightedTextColor
        nil
      end

      def update_cell(cell)
        subform = row.subform.to_form
        if row.display_key && render_row = subform.row(row.display_key)
          rendered_value = render_row.value_for_save_hash
          if render_row.object && render_row.object.respond_to?('row_value')
            rendered_value = render_row.object.row_value
          end
          self.display_key_label.text = rendered_value
        end
      end

      def on_select(tableView, tableViewDelegate)
        subform = row.subform.to_form
        row.form.controller.push_subform(subform)
      end

      def display_key_label
        @display_key_label ||= begin
          label = UILabel.alloc.initWithFrame(CGRectZero)
          label.textColor = "#385387".to_color
          label.tag = LABEL_TAG
          label.backgroundColor = UIColor.clearColor
          label
        end
      end
    end
  end
end
