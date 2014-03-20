motion_require 'base'

module Formotion
  module RowType
    class MapRowData

      attr_accessor :pin, :options
      #attr_accessor :title, :subtitle, :coordinate

      def initialize(options)
        @title=options[:title]
        @subtitle=options[:subtitle]
        @coordinate=options[:coord]
        @options=options[:options]
      end

      def title
        @title
      end

      def subtitle
        @subtitle
      end

      def coordinate
        if @coordinate.is_a? CLCircularRegion
          @coordinate.center
        else
          @coordinate
        end
      end

    end

    class MapRow < Base
      include BW::KVO

      MAP_VIEW_TAG=1100

      def set_pin
        return unless row.value

        unless row.value.is_a?(Hash)
          coord = (row.value.is_a?(Array) and row.value.size==2) ? CLLocationCoordinate2D.new(row.value[0], row.value[1]) : row.value
          row.value = {coord: coord, pin: {coord:coord}}
        end

        # Set Defaults
        row.value = {
          animated: true,
          type: MKMapTypeStandard,
          enabled: true
        }.merge(row.value)

        if row.value[:coord].is_a?(CLLocationCoordinate2D)
          region = MKCoordinateRegionMakeWithDistance(row.value[:coord], 400.0, 480.0)
        elsif row.value[:coord].is_a?(CLCircularRegion)
          region = MKCoordinateRegionMakeWithDistance(
            row.value[:coord].center,
            row.value[:coord].radius * 2,
            row.value[:coord].radius * 2
          )
        else
          return
        end

        if row.value[:pin]
          row.value[:pin] = {title: nil, subtitle:nil}.merge(row.value[:pin]) #Defaults

          @map_row_data = MapRowData.new(row.value[:pin])
          @map_view.removeAnnotations(@map_view.annotations)
          @map_view.addAnnotation(@map_row_data)
          @map_view.selectAnnotation(@map_row_data, animated:row.value[:animated]) if row.value[:pin][:title]
        end

        @map_view.setUserInteractionEnabled(row.value[:enabled])
        @map_view.setMapType(row.value[:type])
        @map_view.setRegion(region, animated:row.value[:animated])
      end

      def annotations
        @map_view.annotations
      end

      def map
        @map_view
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

        nil
      end

      def on_select(tableView, tableViewDelegate)
        if !row.editable?
          return
        end
      end

    end
  end
end
