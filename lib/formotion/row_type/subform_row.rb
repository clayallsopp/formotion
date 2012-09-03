module Formotion
  module RowType
    class SubformRow < Base

      LABEL_TAG=1001

      def build_cell(cell)
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
      end

      def update_cell(cell)
        subform = row.subform.to_form
        if row.display_key and subform.render[row.display_key]
          self.display_key_label.text = subform.render[row.display_key]
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