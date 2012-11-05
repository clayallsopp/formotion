module Formotion
  module RowType
    module ItemsMapper
      def items
        if !row.items
          []
        elsif row.items[0].is_a?(Enumerable)
          row.items
        else
          row.items.map {|i| [i, i]}
        end
      end

      def item_names
        self.items.map { |name, value| name }
      end

      def item_names_hash
        hash = {}
        self.items.each do |name, value|
          hash[name] = value
        end
        hash
      end

      def name_index_of_value(value)
        item_names.index(item_names_hash.invert[value])
      end

      def value_for_name_index(index)
        item_names_hash[item_names[index]]
      end

      def value_for_name(name)
        item_names_hash[name]
      end

      def name_for_value(value)
        item_names_hash.invert[value].to_s
      end
    end
  end
end