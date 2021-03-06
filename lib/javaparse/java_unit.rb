module JavaParse 
    
  class JavaUnit
    
    include LineCounter, MethodGraber
    
    attr_reader :file_name, :unit_name, :body, :head, :methods, :loc, :bloc, :cloc, :all_lines
    
    def initialize(java_file_path)
      @file_path = java_file_path
      @file_name = File.basename(java_file_path)
      @unit_name = File.basename(java_file_path, ".java")
      @content = File.open(@file_path) { |file| file.read }
      validate_unit
      @head, @body = partition_unit
      @methods = grab_methods(@body)
      count_lines
    end
    
    def method_blocks
      return @body.split("}")[0...-1].map{ |block| JavaSection.new(block) } if (clazz? or enum?)
      return @body.split(";")[0...-1].map{ |block| JavaSection.new(block) } if (interface?)
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
      head = removing_above_package(head)
      [JavaSection.new(head.strip!), JavaSection.new(body.strip!.chomp!("}"))]
    end
    
    def removing_above_package(text)
      text.each_line.drop_while {|line|
        not line.strip.start_with?("package")
      }.join
    end
    
  end
  
end