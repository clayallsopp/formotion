module Formotion
  module RowType
    class SubmitRow < Base

      def submit_button?
        true
      end

      # Does a clever little trick to override #layoutSubviews
      # for just this one UITableViewCell object, in order to
      # center it's labels horizontally.
      def build_cell(cell)
        cell.class.send(:alias_method, :old_layoutSubviews, :layoutSubviews)
        cell.instance_eval do
          def layoutSubviews
            old_layoutSubviews

            center = lambda {|frame, dimen|
              ((self.frame.size.send(dimen) - frame.size.send(dimen)) / 2.0)
            }

            self.textLabel.center = CGPointMake(self.frame.size.width / 2 - 10, self.textLabel.center.y)
            self.detailTextLabel.center = CGPointMake(self.frame.size.width / 2 - 10, self.detailTextLabel.center.y)
          end
        end
        nil
      end

      def on_select(tableView, tableViewDelegate)
        tableViewDelegate.submit
      end

    end
  end
end