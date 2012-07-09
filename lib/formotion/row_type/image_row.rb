module Formotion
  module RowType
    class ImageRow < Base

      IMAGE_VIEW_TAG=1100

      def build_cell(cell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        @image_view = UIImageView.alloc.init
        @image_view.image = row.value if row.value
        @image_view.tag = IMAGE_VIEW_TAG
        @image_view.contentMode = UIViewContentModeScaleAspectFit
        cell.accessoryView = @image_view

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(IMAGE_VIEW_TAG)

            field_frame = formotion_field.frame
            field_frame.origin.y = 10
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + 20
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - 20
            field_frame.size.height = self.frame.size.height - 20
            formotion_field.frame = field_frame
          end
        end
      end

      def on_select(tableView, tableViewDelegate)
        action_sheet = UIActionSheet.alloc.init
        if row.value
          action_sheet.destructiveButtonIndex = (action_sheet.addButtonWithTitle "Delete")
        end
        action_sheet.addButtonWithTitle "Take"
        action_sheet.addButtonWithTitle "Choose"

        action_sheet.cancelButtonIndex = (action_sheet.addButtonWithTitle "Cancel")

        action_sheet.delegate = self

        action_sheet.showInView @image_view
      end

      def actionSheet actionSheet, clickedButtonAtIndex: index
        source = nil

        case index
        when actionSheet.destructiveButtonIndex
          row.value = nil
          @image_view.image = nil
        when actionSheet.cancelButtonIndex
        when actionSheet.firstOtherButtonIndex
          source = :camera
        else
          source = :photo_library
        end

        if source
          BW::Device.camera.any.picture(source_type: source, media_types: [:image]) do |result|
            if result[:original_image]
              row.value = result[:original_image]
              @image_view.image = result[:original_image]
            end
          end
        end
      end

    end
  end
end