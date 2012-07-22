require 'rspec'
require 'javaparse'

include JavaParse

describe JavaSection do

  it "should extract javadoc from code sections" do 
    snippet = <<-JAVA
      private int otherStuff() {
      
      }
      /**
      * This is <b>documented</b>
      * This is my method <i>javadoc</i>
      *
      * Here it is
      */
      public void doStuff(Integer value) {
        System.out.println(value)
      }
    JAVA
    section = JavaSection.new(snippet)
    section.javadoc.should == "This is <b>documented</b>\nThis is my method <i>javadoc</i>\n\nHere it is\n"
  end
  
  it "should send empty for empty javadoc" do 
      snippet = <<-JAVA
        private int otherStuff() {
        
        }
        /**
        */
        public void doStuff(Integer value) {
          System.out.println(value)
        }
      JAVA
      section = JavaSection.new(snippet)
      section.javadoc.should == ""
    end
    
    it "should send nil for squeeze empty javadoc" do 
      snippet = <<-JAVA
        private int otherStuff() {
        
        }
        /***/
        public void doStuff(Integer value) {
          System.out.println(value)
        }
      JAVA
      section = JavaSection.new(snippet)
      section.javadoc.should be_nil
    end
end
