# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dyno}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anthony Williams"]
  s.date = %q{2009-05-08}
  s.description = %q{A rubygem for parsing sim-racing results files.}
  s.email = %q{anthony@ninecraft.com}
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["LICENSE", "README.markdown", "Rakefile", "VERSION.yml", "lib/dyno", "lib/dyno/competitor.rb", "lib/dyno/event.rb", "lib/dyno/parsers", "lib/dyno/parsers/gtr2_parser.rb", "lib/dyno/parsers/race07_parser.rb", "lib/dyno/parsers/rfactor_parser.rb", "lib/dyno.rb", "spec/competitor_spec.rb", "spec/event_spec.rb", "spec/fixtures", "spec/fixtures/gtr2", "spec/fixtures/gtr2/full.ini", "spec/fixtures/gtr2/header_no_track.ini", "spec/fixtures/gtr2/header_only.ini", "spec/fixtures/gtr2/no_header_section.ini", "spec/fixtures/gtr2/single_driver.ini", "spec/fixtures/race07", "spec/fixtures/race07/full.ini", "spec/fixtures/race07/header_no_track.ini", "spec/fixtures/race07/header_only.ini", "spec/fixtures/race07/no_header_section.ini", "spec/fixtures/race07/no_steam_id.ini", "spec/fixtures/race07/single_driver.ini", "spec/fixtures/race07/single_driver_dnf.ini", "spec/fixtures/race07/single_driver_dsq.ini", "spec/fixtures/readme.markdown", "spec/fixtures/rfactor", "spec/fixtures/rfactor/arca.xml", "spec/fixtures/rfactor/event_only.xml", "spec/fixtures/rfactor/full.xml", "spec/fixtures/rfactor/missing_root.xml", "spec/fixtures/rfactor/single_driver.xml", "spec/fixtures/rfactor/single_driver_dnf.xml", "spec/fixtures/rfactor/single_driver_dsq.xml", "spec/parsers", "spec/parsers/gtr2_parser_spec.rb", "spec/parsers/race07_parser_spec.rb", "spec/parsers/rfactor_parser_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/anthonyw/dyno}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
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
