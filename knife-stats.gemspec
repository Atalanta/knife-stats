# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-stats/version"

Gem::Specification.new do |s|
  s.name        = "knife-stats"
  s.version     = Knife::Stats::VERSION
  s.authors     = ["Stephen Nelson-Smith", "Fletcher Nichol"]
  s.email       = ["support@atalanta-systems.com"]
  s.homepage    = "https://github.com/Atalanta/knife-stats"
  s.summary     = %q{Provides usage stats for Opscode Chef roles, cookbooks and environments}
  s.description = %q{Provides usage stats for Opscode Chef roles, cookbooks and environments}

  s.rubyforge_project = "knife-stats"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "chef", ">= 0.10.0"
end
