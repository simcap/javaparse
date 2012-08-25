module JavaParse 
  
  module LineCounter
    
    JAVA_COMMENTS_RE = /^\s*\/\/|^\s*\/\*|^\s*\*/ 
    
    def count_lines
      @loc, @bloc, @cloc, @all_lines = 0, 0, 0, 0
      @content.each_line { |line|
        @all_lines += 1
        if line.strip.empty?
          @bloc += 1
        elsif JAVA_COMMENTS_RE.match(line) 
          @cloc += 1 
        else 
          @loc += 1
        end
      } 
      [@loc, @cloc, @bloc, @all_lines]
    end
    
  end
  
end