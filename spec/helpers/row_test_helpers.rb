module Bacon
  class Context
    # Sets up a new @row RowType object to be reset before every test.
    #
    # @param row_settings is a hash of row settings or a symbol
    #   corresponding to a row type
    # @param block is optional; the @row object is passed if given.
    #
    # EX
    # test_row :image
    # => tests the RowType::ImageRow
    # test_row title: "Title", key: "some key", type: :string
    # => tests the RowType::StringRow
    def tests_row(row_settings, &block)
      if row_settings.is_a? Symbol
        type = row_settings
        row_settings = { type: type, key: type, title: type.capitalize.to_s }
      end
      before do
        @row = Formotion::Row.new(row_settings)
        @row.reuse_identifier = 'test'
        block && block.call(@row)
      end
    end
  end
end