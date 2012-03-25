require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

task :default do 
  puts `rake -T`
end

namespace :test do
  desc "Load development gem and starts IRB"
  task :console do
    exec 'irb -I lib -r gateway.rb'
  end
end
