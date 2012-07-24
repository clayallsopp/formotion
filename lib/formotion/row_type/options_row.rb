module Formotion
  module RowType
    class OptionsRow < Base
      include BW::KVO

      SLIDER_VIEW_TAG = 1200

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        slideView = UISegmentedControl.alloc.initWithItems(row.items || [])
        slideView.selectedSegmentIndex = row.items.index(row.value) if row.value
        slideView.segmentedControlStyle = UISegmentedControlStyleBar
        cell.accessoryView = slideView

        slideView.when(UIControlEventValueChanged) do
          break_with_semaphore do
            row.value = row.items[slideView.selectedSegmentIndex]
          end
        end
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            if row.value
              slideView.selectedSegmentIndex = row.items.index(row.value)
            else
              slideView.selectedSegmentIndex = UISegmentedControlNoSegment
            end
          end
        end

        nil
      end


    end
  end
end