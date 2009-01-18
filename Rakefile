require 'rubygems'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name        = 'dyno'
    s.platform    = Gem::Platform::RUBY
    s.has_rdoc    = true
    s.summary     = 'A rubygem for parsing sim-racing results files.'
    s.description = s.summary
    s.author      = 'Anthony Williams'
    s.email       = 'anthony@ninecraft.com'
    s.homepage    = 'http://github.com/anthonyw/dyno'

    s.extra_rdoc_files = ['README.markdown', 'MIT-LICENSE']

    # Dependencies.
    s.add_dependency "iniparse", ">= 0.2.0"

    s.files = %w(MIT-LICENSE README.markdown Rakefile VERSION.yml) +
              Dir.glob("{lib,spec}/**/*")
  end
rescue LoadError
  puts 'Jeweler not available. Install it with: sudo gem install ' +
       'technicalpickles-jeweler -s http://gems.github.com'
end

##############################################################################
# rSpec & rcov
##############################################################################

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ['-c -f s']
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('spec:rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ['-c -f s']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end
