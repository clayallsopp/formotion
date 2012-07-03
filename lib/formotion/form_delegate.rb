module Formotion
  class Form
    attr_reader :table
    attr_reader :controller
    attr_reader :active_row

    def active_row=(row)
      @active_row = row

      if @active_row && @table
        index_path = NSIndexPath.indexPathForRow(@active_row.index, inSection:@active_row.section.index)
        @table.scrollToRowAtIndexPath(index_path, atScrollPosition:UITableViewScrollPositionMiddle,  animated:true)
      end
    end

    ####################
    # Table Methods
    def controller=(controller)
      @controller = controller
      self.table = controller.respond_to?(:table_view) ? controller.table_view : controller.tableView
    end

    def table=(table_view)
      @table = table_view

      @table.delegate = self
      @table.dataSource = self
      reload_data
    end

    def reload_data
      previous_row, next_row = nil

      last_row = self.sections[-1].rows[-1]
      if last_row
        last_row.return_key ||= UIReturnKeyDone
      end

      @table.reloadData
    end

    # UITableViewDataSource Methods
    def numberOfSectionsInTableView(tableView)
      self.sections.count
    end

    def tableView(tableView, numberOfRowsInSection: section)
      self.sections[section].rows.count
    end

    def tableView(tableView, titleForHeaderInSection:section)
      section = self.sections[section].title
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
      row = row_for_index_path(indexPath)
      reuseIdentifier = row.reuse_identifier

      cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
        row.make_cell
      end

      cell
    end

    # UITableViewDelegate Methods
    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      tableView.deselectRowAtIndexPath(indexPath, animated:true)
      row = row_for_index_path(indexPath)
      if row.submit_button?
        self.submit
      elsif row.checkable?
        if row.section.select_one and !row.value
          row.section.rows.each {|other_row|
            other_row.value = (other_row == row)
            Formotion::RowCellBuilder.make_check_cell(other_row, tableView.cellForRowAtIndexPath(other_row.index_path))
          }
        elsif !row.section.select_one
          row.value = !row.value
          Formotion::RowCellBuilder.make_check_cell(row, tableView.cellForRowAtIndexPath(row.index_path))
        end
      elsif row.editable?
        row.text_field.becomeFirstResponder
      end
    end
  end
end