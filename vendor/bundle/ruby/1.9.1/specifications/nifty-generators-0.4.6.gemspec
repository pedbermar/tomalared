# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nifty-generators"
  s.version = "0.4.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.4") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Bates"]
  s.date = "2011-03-26"
  s.description = "A collection of useful Rails generator scripts for scaffolding, layout files, authentication, and more."
  s.email = "ryan@railscasts.com"
  s.homepage = "http://github.com/ryanb/nifty-generators"
  s.require_paths = ["lib"]
  s.rubyforge_project = "nifty-generators"
  s.rubygems_version = "1.8.24"
  s.summary = "A collection of useful Rails generator scripts."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.0.1"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.8"])
      s.add_development_dependency(%q<bcrypt-ruby>, ["~> 2.1.2"])
      s.add_development_dependency(%q<sqlite3-ruby>, ["~> 1.3.1"])
    else
      s.add_dependency(%q<rspec-rails>, ["~> 2.0.1"])
      s.add_dependency(%q<cucumber>, ["~> 0.9.2"])
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_dependency(%q<mocha>, ["~> 0.9.8"])
      s.add_dependency(%q<bcrypt-ruby>, ["~> 2.1.2"])
      s.add_dependency(%q<sqlite3-ruby>, ["~> 1.3.1"])
    end
  else
    s.add_dependency(%q<rspec-rails>, ["~> 2.0.1"])
    s.add_dependency(%q<cucumber>, ["~> 0.9.2"])
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
    s.add_dependency(%q<mocha>, ["~> 0.9.8"])
    s.add_dependency(%q<bcrypt-ruby>, ["~> 2.1.2"])
    s.add_dependency(%q<sqlite3-ruby>, ["~> 1.3.1"])
  end
end
