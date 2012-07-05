module Formotion
  module RowType
    class ControlRow < Base

      SLIDER_VIEW_TAG = 1200

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        slideView = UISegmentedControl.alloc.initWithItems(row.items || [])
        slideView.selectedSegmentIndex = row.items.index(row.value) if row.value
        slideView.segmentedControlStyle = UISegmentedControlStyleBar
        cell.accessoryView = slideView

        slideView.when(UIControlEventValueChanged) do
          row.value = row.items[slideView.selectedSegmentIndex]
        end

        nil
      end


    end
  end
end