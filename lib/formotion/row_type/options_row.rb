module Formotion
  module RowType
    class OptionsRow < Base
      include BW::KVO
      include RowType::ItemsMapper

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone

        segmentedControl = UISegmentedControl.alloc.initWithItems(item_names || [])
        segmentedControl.selectedSegmentIndex = name_index_of_value(row.value) if row.value
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar
        cell.accessoryView = cell.editingAccessoryView = segmentedControl

        segmentedControl.when(UIControlEventValueChanged) do
          break_with_semaphore do
            row.value = value_for_name_index(segmentedControl.selectedSegmentIndex)
          end
        end
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            if row.value
              segmentedControl.selectedSegmentIndex = name_index_of_value(row.value)
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