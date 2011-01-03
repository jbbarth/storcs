require File.expand_path('../helper.rb',__FILE__)

class TestDevice < Test::Unit::TestCase
  def setup
    @bay = Storcs::Device.new("bay1")
    @array1  = Storcs::Device.new("array1"); @array1.real_size = 10; @array1.real_used = 8
    @array2  = Storcs::Device.new("array2"); @array2.real_size = 10; @array2.real_used = 3
    @bay.children << @array1
    @bay.children << @array2
  end

  def test_creation
    assert @bay
    assert_equal "bay1", @bay.name
  end

  def test_basic_nested_methods
    assert_equal 8, @array1.used
    assert_equal 10, @array1.size
    assert_equal 11, @bay.used
    assert_equal 20, @bay.size
    assert_equal 9, @bay.free
  end
end
