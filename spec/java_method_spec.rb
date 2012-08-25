require 'rspec'
require 'javaparse'

include JavaParse

describe JavaMethod do
  
  it "should count the number of methods" do
    clazz = JavaUnit.new(File.expand_path("../../methods-samples/ClazzWithMethods.java", __FILE__))
    
    clazz.methods.size.should == 4

    clazz.methods[0].name.should == "getName"
    clazz.methods[1].name.should == "setSurname"
    clazz.methods[2].name.should == "pseudo"
    clazz.methods[3].name.should == "safePseudo"

    clazz.methods[0].signature.should == "public String getName()"
    clazz.methods[1].signature.should == "public String setSurname(String surname)"
    clazz.methods[2].signature.should == "protected String pseudo()"
    clazz.methods[3].signature.should == "private String safePseudo()"
    
    clazz.methods[0].lines.should == 1
    clazz.methods[1].lines.should == 1
    clazz.methods[2].lines.should == 2
    clazz.methods[3].lines.should == 7
    
    clazz.methods.each { |m| m.clazz.should == "ClazzWithMethods" }
    
  end

end