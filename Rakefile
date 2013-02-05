require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/tc*']
  t.warning = true
end

task :default => [:test]

