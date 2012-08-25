require 'rspec'
require 'javaparse'

include JavaParse

describe JavaUnit do
  
  it "should count the LOC (lines of code)" do
    clazz = JavaUnit.new(File.expand_path("../../sample/SimpleClazz.java", __FILE__))
    clazz.loc.should == 17
  end

  it "should count the BLOC (blank lines of code)" do
    enum = JavaUnit.new(File.expand_path("../../sample/SimpleEnum.java", __FILE__))
    enum.bloc.should == 4
  end

  it "should count the CLOC (comment lines of code)" do
    enum = JavaUnit.new(File.expand_path("../../sample/SimpleEnum.java", __FILE__))
    enum.cloc.should == 9
  end

  it "should count the total number of lines" do
    enum = JavaUnit.new(File.expand_path("../../sample/SimpleEnum.java", __FILE__))
    enum.all_lines.should == 17
  end
  

end