module JavaParse
  
  class JavaMethod
    
    attr_reader :name, :signature, :clazz, :lines
    
    def initialize(clazz, signature, lines_count)
      @clazz = clazz
      @signature = signature.delete('{').strip
      @name = @signature.match(/.*\s(.*)\(.*\)/)[1]
      @lines = lines_count
    end    
    
    def to_s
      "#{self.class}, signature=#{signature}, name=#{name}, class=#{clazz}, lines=#{lines}"
    end
    
  end
  
end