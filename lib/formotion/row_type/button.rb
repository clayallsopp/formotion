module Formotion
  module RowType
    class ButtonRow < Base
      def button?
        true
      end

      # Does a clever little trick to override #layoutSubviews
      # for just this one UITableViewCell object, in order to
      # center it's labels horizontally.
      def build_cell(cell)
        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            center = lambda {|frame, dimen|
              ((self.frame.size.send(dimen) - frame.size.send(dimen)) / 2.0)
            }

            self.textLabel.center = CGPointMake(self.frame.size.width / 2 - (Formotion::RowType::Base.field_buffer / 2), self.textLabel.center.y)
            self.detailTextLabel.center = CGPointMake(self.frame.size.width / 2 - (Formotion::RowType::Base.field_buffer / 2), self.detailTextLabel.center.y)
          end
        end
        nil
      end

      def on_select(tableView, tableViewDelegate)
        # Override in subclasses
        if self.row.on_tap_callback
          self.row.on_tap_callback.call(self.row)
        end
      end
    end
  end
end