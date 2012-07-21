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
  
  context "Extract body & head of the unit" do
    
    it "should return the class unit body" do
      unit = JavaUnit.new(@simple_class)
      expected_body = <<-BODY
          private int hour;private int minute;public void calculateTime() {}
          @Annotated public void rewindTime() {}
          @Annotated @OtherAnnotated void rewindTime() {}
      BODY
      unit.body.gsub(/[\s]/, '').should == expected_body.gsub(/[\s]/, '')
    end

    it "should return the class unit head" do
      unit = JavaUnit.new(@simple_class)
      expected_head = <<-BODY
        package org.mycompany
        import java.util.Date;
        import java.io.BufferedReader;
        import java.io.CharArrayWriter;
      BODY
      unit.head.gsub(/[\s]/, '').should == expected_head.gsub(/[\s]/, '')
    end
    
  end
  
  context "Detection of class, interface, enum" do
  
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
  
  
end