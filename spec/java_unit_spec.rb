require 'rspec'
require 'stringio'
require 'javaparse'

include JavaParse

describe JavaParse::JavaUnit do
  
  before(:all) do
    @simple_class = File.expand_path("../../sample/SimpleClazz.java", __FILE__)
    @simple_enum = File.expand_path("../../sample/SimpleEnum.java", __FILE__)
    @simple_interface = File.expand_path("../../sample/SimpleInterface.java", __FILE__)
    @clazz_with_inner_interface = File.expand_path("../../sample/SimpleClazzWithInnerInterface.java", __FILE__)
    @error_class = File.expand_path("../../sample/ErrorClazzWithWrongClassName.java", __FILE__)
  end
  
  it "should raise error if filename is different form the unit name" do
    expect { JavaUnit.new(@error_class)}.to raise_error(RuntimeError, /#{@error_class}/)
  end

  it "should detect class compilation unit" do
    unit = JavaUnit.new(@simple_class)
    unit.should be_clazz
    unit.should_not be_enum
    unit.should_not be_interface
  end

  it "should detect enum compilation unit" do
    unit = JavaUnit.new(@simple_enum)
    unit.should be_enum
    unit.should_not be_clazz
    unit.should_not be_interface
  end

  it "should detect interface compilation unit" do
    JavaUnit.new(@simple_interface).should be_interface
  end

  it "should detect class compilation unit with confusing comments" do
    unit = JavaUnit.new(@simple_class)
    unit.should be_clazz
    unit.should_not be_interface
  end
  
  it "should detect interface compilation unit with confusing comments" do
    unit = JavaUnit.new(@simple_interface)
    unit.should_not be_clazz
    unit.should be_interface
  end
  
  it "should detect class with inner interface as class" do
    unit = JavaUnit.new(@clazz_with_inner_interface)
    unit.should be_clazz
    unit.should_not be_interface
  end
  
  
end