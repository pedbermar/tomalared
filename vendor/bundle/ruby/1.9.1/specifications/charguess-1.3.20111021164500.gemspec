# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "charguess"
  s.version = "1.3.20111021164500"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ernesto Jim\u{e9}nez"]
  s.date = "2011-10-21"
  s.description = "This gem builds and installs libcharguess and it's binding libcharguess-ruby\n\n* libcharguess: http://libcharguess.sourceforge.net/\n* libcharguess-ruby: http://raa.ruby-lang.org/project/charguess/"
  s.email = ["erjica@gmail.com"]
  s.extensions = ["ext/charguess/extconf.rb"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "ext/charguess/extconf.rb"]
  s.homepage = "http://github.com/ernesto-jimenez/charguess"
  s.post_install_message = "PostInstall.txt"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["ext/charguess", "ext/libcharguess"]
  s.rubyforge_project = "charguess"
  s.rubygems_version = "1.8.24"
  s.summary = "This gem builds and installs libcharguess and it's binding libcharguess-ruby  * libcharguess: http://libcharguess.sourceforge.net/ * libcharguess-ruby: http://raa.ruby-lang.org/project/charguess/"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_development_dependency(%q<hoe>, ["~> 2.12"])
    else
      s.add_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_dependency(%q<hoe>, ["~> 2.12"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.5.3"])
    s.add_dependency(%q<hoe>, ["~> 2.12"])
  end
end
