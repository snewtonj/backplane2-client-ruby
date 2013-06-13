require 'rake/testtask'
require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name        = 'backplane2-client-ruby'
  s.version     = '1.1.0'
  s.date        = '2013-02-05'
  s.description = <<EOF
This library integrates server side Backplane2 clients with the Backplane2 server protocol (https://github.com/janrain/janrain-backplane-2).
EOF
  s.summary     = "Client library for Backplane2"
  s.authors     = ["Steven E. Newton"]
  s.email       = 'steven@janrain.com'
  s.files       = Dir['lib/*.rb']
  s.executables << 'bp2client'
  s.homepage    =
    'http://backplanex.com/'
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/tc*']
  t.warning = true
end

task :default => [:test]

