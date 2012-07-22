require 'rspec'
require 'javaparse'

include JavaParse

describe JavaUnit do

  before(:all) do
    @simple_class = JavaUnit.new(file_path("SimpleClazz.java"))
    @simple_enum = JavaUnit.new(file_path("SimpleEnum.java"))
    @simple_interface = JavaUnit.new(file_path("SimpleInterface.java"))
    @clazz_with_inner_interface = JavaUnit.new(file_path("SimpleClazzWithInnerInterface.java"))
  end
  
  context "Extract methods code blocks from class" do
    
    it "should extract method blocks from body of a class" do
      blocks = @simple_class.method_blocks
      blocks[0].should have_equivalent_code_content "private int hour;private int minute;public void calculateTime() {"
      blocks[1].should have_equivalent_code_content "@Annotatedpublic void rewindTime() {"
      blocks[2].should have_equivalent_code_content "@Annotated@OtherAnnotatedvoid rewindTime() {"
      blocks.size.should == 3
    end
    
    it "should extract method blocks from body of an interface" do
      blocks = @simple_interface.method_blocks
      blocks[0].should have_equivalent_code_content "@Perform public abstract void doStuff()"
      blocks[1].should have_equivalent_code_content "public void doOtherStuff()"
      blocks[2].should have_equivalent_code_content "@Perform @Annotation void doMoreStuff()"
      blocks.size.should == 3
    end
    
  end
  
  context "Extract body & head of the unit" do
    
    it "should return the class unit body" do
      expected_body = <<-BODY
          private int hour;private int minute;public void calculateTime() {}
          @Annotated public void rewindTime() {}
          @Annotated @OtherAnnotated void rewindTime() {}
      BODY
      @simple_class.body.should have_equivalent_code_content expected_body
    end
    
    it "should return the class unit head" do
      expected_head = <<-BODY
        package org.mycompany
        import java.util.Date;
        import java.io.BufferedReader;
        import java.io.CharArrayWriter;
      BODY
      @simple_class.head.should have_equivalent_code_content expected_head
    end
    
    it "head should not contain content above package" do
      @simple_class.head.should start_with("package ")
    end
    
    
    it "should return the interface unit body" do
      expected_body = <<-BODY
    	  @Perform public abstract void doStuff(); 
      	public void doOtherStuff(); 
      	@Perform @Annotation void doMoreStuff(); 
      BODY
      @simple_interface.body.should have_equivalent_code_content expected_body
    end

    it "should return the interface unit head" do
      expected_head = <<-BODY
        package org.mycompany
        import java.util.Date;
      BODY
      @simple_interface.head.should have_equivalent_code_content expected_head
    end
    
  end
  
  context "Detection of class, interface, enum" do
  
    it "should raise error if filename is different form the unit name" do
      expect { JavaUnit.new(file_path("ErrorClazzWithWrongClassName.java"))}.to raise_error(RuntimeError, /#{@error_class}/)
    end

    it "should detect class compilation unit" do
      @simple_class.should be_clazz
      @simple_class.should_not be_enum
      @simple_class.should_not be_interface
    end

    it "should detect enum compilation unit" do
      @simple_enum.should be_enum
      @simple_enum.should_not be_clazz
      @simple_enum.should_not be_interface
    end

    it "should detect interface compilation unit" do
      @simple_interface.should_not be_enum
      @simple_interface.should_not be_clazz
      @simple_interface.should be_interface
    end

    it "should detect class compilation unit with confusing comments" do
      @simple_class.should be_clazz
      @simple_class.should_not be_interface
      @simple_class.should_not be_enum
    end
  
    it "should detect interface compilation unit with confusing comments" do
      @simple_interface.should_not be_clazz
      @simple_interface.should be_interface
      @simple_interface.should_not be_enum
    end
  
    it "should detect class with inner interface as class" do
      @clazz_with_inner_interface.should be_clazz
      @clazz_with_inner_interface.should_not be_interface
    end
  end
  
  # Matches two java content removing comments, whitespaces and empty lines
  RSpec::Matchers.define :have_equivalent_code_content do |expected|
    match do |actual|
      actual.gsub(/^(\s*\*|\s*\/).*$|[\s]/, '').gsub(/^$\n/, '') \
        == expected.gsub(/^(\s*\*|\s*\/).*$|[\s]/, '').gsub(/^$\n/, '')
    end
  end
  
  def file_path(class_name)
    File.expand_path("../../sample/#{class_name}", __FILE__)
  end
  
  
end