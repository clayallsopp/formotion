module Formotion
  module RowType
    class DummyRow < Base
    end
  end
end

describe "Base Row Type" do

  describe '#on_select' do
    tests_row :dummy

    it "should return false if callback is not defined" do
      @row.object.on_select(nil, nil).should == false
    end

    describe 'when on_tap_callback is set' do
      tests_row :dummy do |row|
        row.on_tap { |row| @called = true }
      end

      before do
        @called = false
      end

      it "should return true" do
        @row.object.on_select(nil, nil).should == true
      end

      it "should call the callback" do
        @row.object.on_select(nil, nil)
        @called.should == true
      end

    end

  end
end
