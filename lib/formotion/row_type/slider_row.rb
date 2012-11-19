module Formotion
  module RowType
    class SliderRow < Base
      include BW::KVO

      SLIDER_VIEW_TAG = 1200

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        slideView = UISlider.alloc.initWithFrame(CGRectZero)
        cell.accessoryView = cell.editingAccessoryView = slideView
        row.range ||= (1..10)
        slideView.minimumValue = row.range.first
        slideView.maximumValue = row.range.last
        slideView.tag = SLIDER_VIEW_TAG
        slideView.setValue(row.value, animated:true) if row.value
        slideView.accessibilityLabel = (row.title || "") + " Slider"

        slideView.when(UIControlEventValueChanged) do
          break_with_semaphore do
            row.value = slideView.value
          end
        end
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            slideView.setValue(row.value, animated:false)
          end
        end


        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(SLIDER_VIEW_TAG)
            formotion_field.sizeToFit

            field_frame = formotion_field.frame
            field_frame.origin.y = 10
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            field_frame.size.height = self.frame.size.height - Formotion::RowType::Base.field_buffer
            formotion_field.frame = field_frame
          end
        end
        nil
      end

    end
  end
end