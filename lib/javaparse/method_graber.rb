module JavaParse
  
  class MethodMatch
    
    attr_reader :signature, :method_text
    
    def initialize(signature, method_text)
      @signature = signature
      @method_text = method_text
    end
    
    def inner_lines_count
      @method_text.lines.inject(-2){|sum| sum + 1}
    end

  end
  
  module MethodGraber
    
    def grab_methods(clazz_body)
      methods = []
      method_matches = match_method_bodies(clazz_body.content)
      method_matches.each { |match|
        methods << JavaMethod.new(unit_name, match.signature, match.inner_lines_count )
      }      
      methods
    end
    
    def match_method_bodies(text)
      method_matches = []
      while match = match_method_signature(text)
        rtext = text[match.begin(0)..-1]
        method_text = ""
        open_brackets_counter = 0
        rtext.each_char.with_index { |c, i|
          open_brackets_counter = open_brackets_counter + 1 if '{' == c 
          open_brackets_counter = open_brackets_counter - 1 if '}' == c 
          method_text << c
          break if ('}' == c && open_brackets_counter == 0)
        }
        method_matches << MethodMatch.new(match[0], method_text)
        end_of_method_index = match.begin(0) + method_text.length
        text = text[end_of_method_index..-1]
      end
      method_matches
    end    
    
    def match_method_signature(text)
      text.match(/(?:public|private|protected).*\(.*\)\s*({$)/)
    end
    
  end
  
end