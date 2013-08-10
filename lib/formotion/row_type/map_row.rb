motion_require 'base'

module Formotion
  module RowType
    class MapRowData
  
      attr_accessor :pin, :options
      #attr_accessor :title, :subtitle, :coordinate
  
      def initialize(title, subtitle, coordinate, options={})
        @title=title
        @subtitle=subtitle
        @coordinate=coordinate
        @options=options
      end
      
      def title
        @title
      end
      
      def subtitle
        @subtitle
      end
      
      def coordinate
        @coordinate
      end
  
    end
    
    class MapRow < Base
      include BW::KVO

      MAP_VIEW_TAG=1100

      def set_pin
        return unless row.value
        coord = (row.value.is_a?(Array) and row.value.size==2) ? CLLocationCoordinate2D.new(row.value[0], row.value[1]) : row.value
        if coord.is_a?(CLLocationCoordinate2D)
          @map_view.removeAnnotation(@map_row_data) if @map_row_data
          region = MKCoordinateRegionMakeWithDistance(coord, 400.0, 480.0)
          @map_row_data = MapRowData.new(nil, nil, coord)
          @map_view.setRegion(region, animated:true)
          @map_view.addAnnotation(@map_row_data)
        end
      end
      
      def annotations
        @map_view.annotations
      end

      def build_cell(cell)
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleBlue

        @map_view = MKMapView.alloc.init
        @map_view.delegate = self
        
        set_pin
        
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            set_pin
          end
        end
        
        @map_view.tag = MAP_VIEW_TAG
        @map_view.contentMode = UIViewContentModeScaleAspectFit
        @map_view.backgroundColor = UIColor.clearColor
        cell.addSubview(@map_view)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(MAP_VIEW_TAG)

            field_frame = formotion_field.frame
            field_frame.origin.y = 10
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.size.width  = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer
            field_frame.size.height = self.frame.size.height - Formotion::RowType::Base.field_buffer
            formotion_field.frame = field_frame
          end
        end
      end

      def on_select(tableView, tableViewDelegate)
        if !row.editable?
          return
        end
      end

    end
  end
end
