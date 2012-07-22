module JavaParse  
  
  class JavaUnit
    
    attr_reader :body, :head
    
    def initialize(java_file_path)
      @file_path = java_file_path
      @unit_name = File.basename(java_file_path, ".java")
      @content = File.open(java_file_path) { |file| file.read }
      validate_unit
      @head, @body = partition_unit
    end
    
    def method_blocks
      if (clazz? or enum?)
        sections = @body.split("}")
        sections.pop
        return sections
      end
      if interface? 
        sections = @body.split(";") 
        sections.pop
        return sections
      end  
    end
        
    def clazz?
        unit_declaration_line.include? 'class'
    end

    def interface?
        unit_declaration_line.include? 'interface'
    end

    def enum?
        unit_declaration_line.include? 'enum'
    end
    
    private 
    
    def validate_unit
      raise RuntimeError, "Mismatch between filename and declared name for #{@file_path}" unless unit_declaration_line
    end
    
    def unit_declaration_line
      declaration_line_match = /^.*(?<=class|enum|interface)\s*#{@unit_name}.*$/.match(@content)
      declaration_line_match[0] unless declaration_line_match.nil?
    end
    
    def partition_unit
      head, match, body = @content.partition(unit_declaration_line)
      [head.strip!, body.strip!.chomp!("}")]
    end
    
  end
  
end