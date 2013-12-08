describe "FormController/MapRow" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Map",
      key: :map,
      type: :map,
      value: [47.5, 8.5]
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def map_row
    @form.row(:map)
  end

  it "should have only one pin" do
    map_row.object.annotations.size.should == 1
  end

  it "should be a pin at the predefined position" do
    coord = map_row.object.annotations[0].coordinate
    coord.latitude.should == 47.5
    coord.longitude.should == 8.5
  end

  it "should set a new pin with new position" do
    map_row.value = CLLocationCoordinate2D.new(48.5, 9.5)
    wait 1 do
      map_row.object.annotations.size.should == 1
      coord = map_row.object.annotations[0].coordinate
      coord.latitude.should == 48.5
      coord.longitude.should == 9.5
    end
  end

  it "should have the default map type" do
    wait 1 do
      map_row.object.map.mapType.should == MKMapTypeStandard
    end
  end

  it "should allow map interaction" do
    wait 1 do
      map_row.object.map.isUserInteractionEnabled.should == true
    end
  end

end

describe "FormController/MapRow MapType" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Map",
      key: :map,
      type: :map,
      value: {
        coord: CLLocationCoordinate2D.new(48.5, 9.5),
        type: MKMapTypeHybrid,
        enabled: false
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def map_row
    @form.row(:map)
  end

  it "should have the hybrid map type" do
    wait 1 do
      map_row.object.map.mapType.should == MKMapTypeHybrid
    end
  end

  it "should not allow map interaction" do
    wait 1 do
      map_row.object.map.isUserInteractionEnabled.should == false
    end
  end

end

describe "FormController/MapRow Pin" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Map",
      key: :map,
      type: :map,
      value: {
        coord: CLLocationCoordinate2D.new(48.5, 9.5),
        pin: {
          coord: CLLocationCoordinate2D.new(48.4, 9.4),
          title: "Formotion",
          subtitle: "Is Awesome"
        }
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def map_row
    @form.row(:map)
  end

  it "should have only one pin" do
    map_row.object.annotations.size.should == 1
  end

  it "should be a pin at the predefined position" do
    coord = map_row.object.annotations[0].coordinate
    coord.latitude.should.be.close 48.4, 0.2
    coord.longitude.should.be.close 9.4, 0.2
  end

  it "should be different than the map center" do
    pin_coord = map_row.object.annotations[0].coordinate
    map_center = map_row.object.map.centerCoordinate

    pin_coord.should.not.be.same_as map_center
  end

  it "should have a title" do
    pin = map_row.object.annotations[0]
    pin.title.should == "Formotion"
  end

  it "should have a subtitle" do
    pin = map_row.object.annotations[0]
    pin.subtitle.should == "Is Awesome"
  end

end

describe "FormController/MapRow No Pin" do
  tests Formotion::FormController

  # By default, `tests` uses @controller.init
  # this isn't ideal for our case, so override.
  def controller
    row_settings = {
      title: "Map",
      key: :map,
      type: :map,
      value: {
        coord: CLLocationCoordinate2D.new(48.5, 9.5),
        pin: nil
      }
    }
    @form ||= Formotion::Form.new(
      sections: [{
        rows:[row_settings]
    }])

    @controller ||= Formotion::FormController.alloc.initWithForm(@form)
  end

  def map_row
    @form.row(:map)
  end

  it "should have zero pins" do
    map_row.object.annotations.size.should == 0
  end

end
