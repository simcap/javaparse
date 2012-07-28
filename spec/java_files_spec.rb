require 'rspec'
require 'javaparse'

include JavaParse

describe JavaFiles do
  
  context "Counting files" do
   
    it "should count the valid java files collected" do
      JavaFiles.new(full_path("collect-samples"), full_path("sample")).count.should == 10
    end

    it "should count the valid java files collected not counting twice the same file" do
      JavaFiles.new(full_path("collect-samples"), full_path("sample"), full_path("sample")).count.should == 10
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