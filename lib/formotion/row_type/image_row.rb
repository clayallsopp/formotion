module Formotion
  module RowType
    class ImageRow < Base
      include BW::KVO

      IMAGE_VIEW_TAG=1100

      def build_cell(cell)
        add_plus_accessory(cell)

        observe(self.row, "value") do |old_value, new_value|
          @image_view.image = new_value
          if new_value
            self.row.rowHeight = 200
            cell.accessoryView = nil
          else
            self.row.rowHeight = 44
            add_plus_accessory(cell)
          end
          row.form.reload_data
        end

        @image_view = UIImageView.alloc.init
        @image_view.image = row.value if row.value
        @image_view.tag = IMAGE_VIEW_TAG
        @image_view.contentMode = UIViewContentModeScaleAspectFit
        @image_view.backgroundColor = UIColor.clearColor
        cell.addSubview(@image_view)

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
        @action_sheet = UIActionSheet.alloc.init
        @action_sheet.delegate = self

        @action_sheet.destructiveButtonIndex = (@action_sheet.addButtonWithTitle "Delete") if row.value
        @action_sheet.addButtonWithTitle "Take" if BW::Device.camera.front? or BW::Device.camera.rear?
        @action_sheet.addButtonWithTitle "Choose"
        @action_sheet.cancelButtonIndex = (@action_sheet.addButtonWithTitle "Cancel")

        @action_sheet.showInView @image_view
      end

      def actionSheet actionSheet, clickedButtonAtIndex: index
        source = nil

        if index == actionSheet.destructiveButtonIndex
          row.value = nil
          return
        end

        case actionSheet.buttonTitleAtIndex(index)
        when "Take"
          source = :camera
        when "Choose"
          source = :photo_library
        when "Cancel"
        else
          p "Unrecognized button title #{actionSheet.buttonTitleAtIndex(index)}"
        end

        if source
          @camera = BW::Device.camera.any
          @camera.picture(source_type: source, media_types: [:image]) do |result|
            if result[:original_image]
              row.value = result[:original_image]
            end
          end
        end
      end

      def add_plus_accessory(cell)
        @add_button ||= begin
          button = UIButton.buttonWithType(UIButtonTypeContactAdd)
          button.when(UIControlEventTouchUpInside) do
            self.on_select(nil, nil)
          end
          button
        end
        cell.accessoryView = @add_button
      end
    end
  end
end