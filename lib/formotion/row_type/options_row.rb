module Formotion
  module RowType
    class OptionsRow < Base
      include BW::KVO

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        segmentedControl = UISegmentedControl.alloc.initWithItems(row.items || [])
        segmentedControl.selectedSegmentIndex = row.items.index(row.value) if row.value
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar
        cell.editingAccessoryView = segmentedControl

        segmentedControl.when(UIControlEventValueChanged) do
          break_with_semaphore do
            row.value = row.items[segmentedControl.selectedSegmentIndex]
          end
        end
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            if row.value
              segmentedControl.selectedSegmentIndex = row.items.index(row.value)
            else
              segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
            end
          end
        end

        nil
      end


    end
  end
end