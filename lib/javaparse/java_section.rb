module JavaParse
  
  class JavaSection
    
    def initialize(section_text)
      @content = section_text
    end
    
    def javadoc
      @javadoc ||= parse_javadoc
    end
    
    def content
      @content
    end
    
    def method_missing(method, *args, &blk)
      @content.send(method, *args)
    end
    
    private 
    
    def parse_javadoc
      javadoc_match = /\/\*\*(.+)\*\//m.match(@content)
      @javadoc = javadoc_match[1][1...-1].each_line.map { 
        |l| l.gsub("*", '').gsub(/\*|^ +| +$/, '') 
      }.join if javadoc_match
    end
    
  end
    
end