motion_require 'base'

module Formotion
  module RowType
    class MapviewRowData
  
      attr_accessor :pin
  
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
  
      def options(ref)
        return @options[ref] if @options.is_a?(Hash)
        return nil
      end
  
    end
    
    class MapviewRow < Base

      include BW::KVO

      MAP_VIEW_TAG=1100

      def build_cell(cell)
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleBlue

        @map_view = MKMapView.alloc.init
        @map_view.delegate = self
        if row.value
          coord = row.value
          if row.value.is_a?(Array) and row.value.size==2
            coord = CLLocationCoordinate2D.new(row.value[0], row.value[1])
          end
          if coord.is_a?(CLLocationCoordinate2D)
            region = MKCoordinateRegionMakeWithDistance(coord, 400.0, 480.0)
            @map_view.setRegion(region, animated:true)
            m=MapviewRowData.new(nil, nil, coord)
            @map_view.addAnnotation(m)
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
