# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dyno}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anthony Williams"]
  s.date = %q{2009-01-15}
  s.description = %q{A rubygem for parsing sim-racing results files.}
  s.email = %q{anthony@ninecraft.com}
  s.extra_rdoc_files = ["README.markdown", "MIT-LICENSE"]
  s.files = ["MIT-LICENSE", "README.markdown", "Rakefile", "VERSION.yml", "lib/dyno", "lib/dyno/competitor.rb", "lib/dyno/event.rb", "lib/dyno/parsers", "lib/dyno/parsers/race07_parser.rb", "lib/dyno.rb", "spec/competitor_spec.rb", "spec/event_spec.rb", "spec/fixtures", "spec/fixtures/race07", "spec/fixtures/race07/full.ini", "spec/fixtures/race07/header_no_track.ini", "spec/fixtures/race07/header_only.ini", "spec/fixtures/race07/no_header_section.ini", "spec/fixtures/race07/no_steam_id.ini", "spec/fixtures/race07/readme.markdown", "spec/fixtures/race07/single_driver.ini", "spec/parsers", "spec/parsers/race07_parser_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/anthonyw/dyno}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{A rubygem for parsing sim-racing results files.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<iniparse>, [">= 0.2.0"])
    else
      s.add_dependency(%q<iniparse>, [">= 0.2.0"])
    end
  else
    s.add_dependency(%q<iniparse>, [">= 0.2.0"])
  end
end
