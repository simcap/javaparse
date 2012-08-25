Dir.glob("#{File.dirname(File.expand_path(__FILE__))}/lib/**/*.rb").map{|file_path| file_path.match(/javaparse\/(.*)/)[1]}

Gem::Specification.new do |s|
  s.name = "javaparse"
  s.version = "0.1.3"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Simon Caplette"]
  s.summary = %q{Parsing info from Java files}

  s.rubyforge_project = "javaparse"
  s.files = Dir.glob("#{File.dirname(File.expand_path(__FILE__))}/lib/**/*.rb")
                .map{|file_path| file_path.match(/javaparse\/(.*)/)[1]}
end