module JavaParse
  
  class JavaFiles
    
    def initialize(*directories)
      @java_units = []
      directories.uniq.each { |directory|
        @java_units.concat(Dir.glob("#{directory}/**/*.java").map { |path| 
            begin
              JavaUnit.new(path)
            rescue 
              nil
            end
          }.select {|el| not el.nil?})
      }
    end
    
    def count(type = :files)
      return @java_units.inject(0) { |sum, java_unit| sum + java_unit.send(type)} if [:bloc, :cloc, :loc].include? type.to_sym
      return @java_units.size if type == :files
      raise "Do not know how to count type #{type}"
    end
    
  end
  
end