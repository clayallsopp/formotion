module Formation
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
      self.table = controller.table_view
    end

    def table=(table_view)
      @table = table_view

      @table.delegate = self
      @table.dataSource = self
      reload_data
    end

    def reload_data
      previous_row, next_row = nil

      self.sections.each_with_index {|section, section_index|
        next_section = nil
        if section_index + 1 < self.sections.count
          next_section = sections[section_index + 1]
        end

        section.rows.each_with_index { |row, row_index|
          if (row_index + 1) < section.rows.count
            next_row = section.rows[row_index + 1]
          else
            if next_section && next_section.rows.count > 0
              next_row = next_section.rows[0]
            end
          end

          row.previous_row = previous_row
          row.next_row = next_row

          previous_row = row
        }
      }

      if previous_row
        previous_row.return_key ||= UIReturnKeyDone
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
      if row.checkable?
        if row.section.select_one and !row.value
          row.section.rows.each {|other_row|
            other_row.value = (other_row == row)
            Formation::RowCellBuilder.make_check_cell(other_row, tableView.cellForRowAtIndexPath(other_row.index_path))
          }
        elsif !row.section.select_one
          row.value = !row.value
          Formation::RowCellBuilder.make_check_cell(row, tableView.cellForRowAtIndexPath(row.index_path))
        end
      elsif row.editable?
        row.field.becomeFirstResponder
      end
    end
  end
end