# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rash"
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["tcocca"]
  s.date = "2011-11-29"
  s.description = "simple extension to Hashie::Mash for rubyified keys, all keys are converted to underscore to eliminate horrible camelCasing"
  s.email = "tom.cocca@gmail.com"
  s.homepage = "http://github.com/tcocca/rash"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "simple extension to Hashie::Mash for rubyified keys"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hashie>, ["~> 1.2.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.9"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5"])
    else
      s.add_dependency(%q<hashie>, ["~> 1.2.0"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rdoc>, ["~> 3.9"])
      s.add_dependency(%q<rspec>, ["~> 2.5"])
    end
  else
    s.add_dependency(%q<hashie>, ["~> 1.2.0"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rdoc>, ["~> 3.9"])
    s.add_dependency(%q<rspec>, ["~> 2.5"])
  end
end
