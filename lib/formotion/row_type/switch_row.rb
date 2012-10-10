module Formotion
  module RowType
    class SwitchRow < Base
      include BW::KVO

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        switchView = UISwitch.alloc.initWithFrame(CGRectZero)
        switchView.accessibilityLabel = (row.title || "") + " Switch"
        cell.accessoryView = cell.editingAccessoryView = switchView
        switchView.setOn(row.value || false, animated:false)
        switchView.when(UIControlEventValueChanged) do
          break_with_semaphore do
            row.value = switchView.isOn
          end
        end
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            switchView.setOn(row.value || false, animated: false)
          end
        end
        nil
      end

    end
  end
end