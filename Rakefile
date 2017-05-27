require "rake/testtask"
require "bundler/gem_tasks"
task :default => :test

desc 'Run test_unit based test'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir["test/**/test_*.rb"]
  t.verbose = true
end
