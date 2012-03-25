require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

task :default do 
  puts `rake -T`
  
end

namespace :test do
  desc "Load development gem and starts IRB"
  task :console do
    exec 'irb -I lib -r polvomenu.rb'
  end
end

namespace :gem do
  desc "Deletes built gem files"
  task :clean do
    `rm polvomenu-*.gem `
  end

  desc "Cleans all the gem files, creates a new one, push it to rubygems and installs it "
  task :release_new_version do
    `rm polvomenu-*.gem `
    `gem build polvomenu.gemspec`
    `gem push polvomenu-*.gem`
    `gem uninstall polvomenu`
    `gem install polvomenu`
  end


  desc "Cleans all the gem files, creates a new one, installs it "
  task :install_local do
    `rm polvomenu-*.gem `
    `gem build polvomenu.gemspec`
    `gem uninstall polvomenu`
    `gem install polvomenu-*.gem`
  end

end
