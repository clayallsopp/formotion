module Formotion
  module RowType
    class SwitchRow < Base
      include BW::KVO

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        switchView = UISwitch.alloc.initWithFrame(CGRectZero)
        switchView.accessibilityLabel = row.title + " Switch"
        cell.accessoryView = switchView
        switchView.setOn(row.value || false, animated:false)
        switchView.when(UIControlEventValueChanged) do
          break if @semaphore
          @semaphore = true
          row.value = switchView.isOn
          @semaphore = false
        end
        observe(self.row, "value") do |old_value, new_value|
          break if @semaphore
          @semaphore = true
          switchView.setOn(row.value || false, animated: false)
          @semaphore = false
        end
        nil
      end

    end
  end
end