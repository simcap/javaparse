require 'rspec'
require 'javaparse'

include JavaParse

describe JavaFiles do
  
  it "'each' should iterates through the files collected" do
    files = JavaFiles.new(full_path("collect-samples/one"))
    actual = []
    files.each { |file|
      actual << file.file_name
    }
    actual.size.should == 2
    actual[0].should == "OneOtherSimple.java"
    actual[1].should == "OneSimple.java"
  end
  
  context "Counting files" do
   
    it "should count the valid java files collected" do
      JavaFiles.new(full_path("collect-samples"), full_path("sample")).count.should == 10
    end

    it "should count the valid java files collected not counting twice the same file" do
      JavaFiles.new(full_path("collect-samples/one"), full_path("collect-samples"), full_path("sample")).count.should == 10
    end

    it "should count 0 when no java files found" do
      JavaFiles.new(full_path("lib")).count.should == 0
    end
    
  end
  
  context "Counting lines of code" do
    
    it "should count the LOC (line of codes)" do
      JavaFiles.new(full_path("collect-samples"), full_path("sample")).count(:loc).should == 54
    end

    it "should count the BLOC (blank line of codes)" do
      JavaFiles.new(full_path("collect-samples"), full_path("sample")).count("bloc").should == 41
    end

    it "should count the CLOC (comment line of codes)" do
      JavaFiles.new(full_path("collect-samples"), full_path("sample")).count(:cloc).should == 24
    end

    it "should count all the lines from the files" do
      JavaFiles.new(full_path("collect-samples"), full_path("sample")).count(:all_lines).should == 119
    end

    it "should raise exception if counting invalid type" do
      expect { 
        JavaFiles.new(full_path("collect-samples"), full_path("sample")).count(:invalid)
      }.to raise_error(RuntimeError, /invalid/)
      
    end
    
  end
  
  private 
  
  def full_path(directory)
    File.expand_path("../../#{directory}", __FILE__)
  end

end