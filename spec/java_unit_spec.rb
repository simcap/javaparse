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
  
  context "Extract methods code blocks from class" do
    
    it "should extract method blocks from body of a class" do
      unit = JavaUnit.new(@simple_class)
      blocks = unit.method_blocks
      blocks[0].gsub(/[\s]/, '').should == "private int hour;private int minute;public void calculateTime() {".gsub(/[\s]/, '')
      blocks[1].gsub(/[\s]/, '').should == "@Annotatedpublic void rewindTime() {".gsub(/[\s]/, '')
      blocks[2].gsub(/[\s]/, '').should == "@Annotated@OtherAnnotatedvoid rewindTime() {".gsub(/[\s]/, '')
      blocks.size.should == 4
    end
    
    it "should extract method blocks from body of an interface" do
      unit = JavaUnit.new(@simple_interface)
      blocks = unit.method_blocks
      blocks[0].gsub(/[\s]/, '').should == "@Perform public abstract void doStuff()".gsub(/[\s]/, '')
      blocks[1].gsub(/[\s]/, '').should == "public void doOtherStuff()".gsub(/[\s]/, '')
      blocks[2].gsub(/[\s]/, '').should == "@Perform @Annotation void doMoreStuff()".gsub(/[\s]/, '')
      blocks.size.should == 4
    end
    
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
    
    it "should return the interface unit body" do
      unit = JavaUnit.new(@simple_interface)
      expected_body = <<-BODY
    	  @Perform public abstract void doStuff(); 
      	public void doOtherStuff(); 
      	@Perform @Annotation void doMoreStuff(); 
      BODY
      unit.body.gsub(/[\s]/, '').should == expected_body.gsub(/[\s]/, '')
    end

    it "should return the interface unit head" do
      unit = JavaUnit.new(@simple_interface)
      expected_head = <<-BODY
        package org.mycompany
        import java.util.Date;
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