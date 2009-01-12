require 'rubygems'
require "rake/clean"
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'spec/rake/spectask'
# require 'date'

GEM = "dyno"
DYNO_VERSION = "0.0.2"

##############################################################################
# Packaging & Installation
##############################################################################

CLEAN.include ['pkg', '*.gem', 'doc', 'coverage', 'cache']
SUDO = ((PLATFORM =~ /win32|cygwin/) rescue nil) ? "" : "sudo"

spec = Gem::Specification.new do |s|
  s.name        = GEM
  s.version     = DYNO_VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc    = true
  s.summary     = 'A gem for parsing sim-racing results files.'
  s.description = s.summary
  s.author      = 'Anthony Williams'
  s.email       = 'anthony@ninecraft.com'
  s.homepage    = 'http://github.com/anthonyw/dyno'

  s.extra_rdoc_files = ['README.markdown', 'MIT-LICENSE', 'TODO']

  # Dependencies.
  s.add_dependency "iniparse", ">= 0.2.0"

  s.require_path = 'lib'
  s.files = %w(MIT-LICENSE README.markdown Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Run :package and install the resulting .gem"
task :install => :package do
  sh %{#{SUDO} gem install --local pkg/#{GEM}-#{DYNO_VERSION}.gem}
end

desc "Run :clean and uninstall the .gem"
task :uninstall => :clean do
  sh %{#{SUDO} gem uninstall #{GEM}}
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

################################################################################
# rSpec & rcov
################################################################################

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
