GEMSPEC_VERSION_RE = /s\.version\s*=\s*\"(\d\.\d\.\d)\"/

desc 'Run specs'
task :spec do
	spec = `rspec spec`
	failures = spec.match(/(\d{1,})\sfailure/)[1].to_i
	if failures > 0
	  abort("Aborting. There are #{failures} test failures.")
	else 
	  puts "Running specs OK"
	end
end

desc 'Upgrade current version of gem'
task :upgrade_gem_version do
    text = File.read("javaparse.gemspec")
    current_gem_version_match = text.match(GEMSPEC_VERSION_RE)
    if current_gem_version_match
      current_gem_version = current_gem_version_match[1]
      next_gem_version = current_gem_version.succ
      puts "Upgrading gem from #{current_gem_version} to #{next_gem_version}"
      text.gsub!(current_gem_version, next_gem_version)
      File.open("javaparse.gemspec", 'w') { |f| f.write(text)}
    else 
      puts "Could not find a gemspec version."
    end
end

desc 'Remove gem files'
task :clean_gems do
  gem_files = Dir.glob("*.gem")
  unless gem_files.empty?
    puts "Removing gem files #{gem_files}" 
    FileUtils.rm Dir.glob("*.gem")
  end
end

