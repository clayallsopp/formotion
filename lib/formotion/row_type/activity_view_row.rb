motion_require 'object_row'

module Formotion
  module RowType
    class ActivityRow < ObjectRow

      def after_build(cell)
        super

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        self.row.text_field.hidden = true

        row.value = {items:[row.value]} unless row.value.is_a?(Hash)
        row.value = {
          excluded: [],
          animated: true,
          app_activities: nil,
          completion: nil
        }.merge(row.value)
        row.value[:items] = [row.value[:items]] unless row.value[:items].is_a?(Array)

      end

      def on_select(tableView, tableViewDelegate)
        activity_vc = UIActivityViewController.alloc.initWithActivityItems(row.value[:items], applicationActivities:row.value[:app_activities])
        activity_vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical
        activity_vc.excludedActivityTypes = row.value[:excluded]

        row.form.controller.presentViewController(activity_vc, animated:row.value[:animated], completion:row.value[:completion])
      end

    end
  end
end
