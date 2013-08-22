describe "FormController/TemplateRowExt" do
  tests Formotion::FormController

  class Item
    attr_accessor :name
  
    def initialize(name)
      @name=name
    end
  
    def to_s
      @name
    end
  end

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    @item1 = Item.new("Value 1")
    row_settings = {
      title: "Add element",
      key: :template,
      type: :template,
      value: [@item1],
      template: {
        title: 'Element',
        type: :object,
        indented: true,
        deletable: true
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def new_row
    @form.sections.first.rows[-2]
  end

  after do
    @form = nil
    @controller = nil
  end

  it "should work with DSL" do
    @form = Formotion::Form.new

    item2 = Item.new("Value 2")
    @form.build_section do |section|
      section.build_row do |row|
        row.title = "Add element"
        row.type = :template
        row.key = :template
        row.value = [@item1, item2]
        row.template = {
          title: 'Element',
          type: :object,
          indented: true,
          deletable: true
        }
      end
    end

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
    @form.render[:template].should == [@item1, item2]
  end

  it "should insert row" do
    tap("Add element")
    @form.sections.first.rows.size.should == 3
  end

  it "should remove row" do
    tap("Add element")
    new_row.object.on_delete(nil, nil)
    @form.sections.first.rows.size.should == 2
  end

  it "should render values as array" do
    tap("Add element")
    item2 = Item.new("Value 2")
    new_row.value = item2

    tap("Add element")
    item3 = Item.new("Value 3")
    new_row.value = item3

    @form.render[:template].should == [@item1, item2, item3]
  end
  
  it "should call on_tap on the specific element" do
    @tapped_item = nil
    row = @form.row(:template)
    row.on_tap do |row|
      @tapped_item = row.value
    end
    
    tap("Element")
    wait 1 do
      @tapped_item.class.should == Item
      @tapped_item.to_s.should == "Value 1"
    end
      
  end
  
  it "should call on_tap on a newly added element" do
    @tapped_item = nil
    row = @form.row(:template)
    row.on_tap do |row|
      @tapped_item = row.value
    end
    
    # patch template to get an new title for the element
    row.template[:title] = "Value 2"
    tap("Add element")
    item2 = Item.new("Value 2")
    new_row.value = item2
    
    tap("Value 2")
    wait 1 do
      @tapped_item.class.should == Item
      @tapped_item.to_s.should == "Value 2"
    end
      
  end
  
end