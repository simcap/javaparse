module JavaParse
  
  class JavaFiles
    
    def initialize(*directories)
      @java_units = []
      paths = directories.map { |directory|
        Dir.glob("#{directory}/**/*.java")
      }.flatten
      paths.uniq!
      paths.each { |path| 
            begin
              @java_units.push(JavaUnit.new(path))
            rescue 
              nil
            end
      }
    end
    
    def count(type = :files)
      return @java_units.inject(0) { |sum, java_unit| sum + java_unit.send(type)} if [:bloc, :cloc, :loc].include? type.to_sym
      return @java_units.size if type == :files
      raise "Do not know how to count type #{type}"
    end
    
  end
  
end