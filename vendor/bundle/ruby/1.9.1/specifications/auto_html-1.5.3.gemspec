# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "auto_html"
  s.version = "1.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dejan Simic"]
  s.date = "2012-05-08"
  s.description = "Automatically transforms URIs (via domain) and includes the destination resource (Vimeo, YouTube movie, image, ...) in your document"
  s.email = "desimic@gmail.com"
  s.homepage = "http://github.com/dejan/auto_html"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Transform URIs to appropriate markup"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rinku>, ["~> 1.5.0"])
      s.add_runtime_dependency(%q<redcarpet>, ["~> 2.0.0"])
    else
      s.add_dependency(%q<rinku>, ["~> 1.5.0"])
      s.add_dependency(%q<redcarpet>, ["~> 2.0.0"])
    end
  else
    s.add_dependency(%q<rinku>, ["~> 1.5.0"])
    s.add_dependency(%q<redcarpet>, ["~> 2.0.0"])
  end
end
