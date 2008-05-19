require 'rake/gempackagetask'

task :clean => :clobber_package

spec = Gem::Specification.new do |s|
  s.name                  = HasBrowser::NAME
  s.version               = HasBrowser::Version::STRING
  s.platform              = Gem::Platform::RUBY
  s.summary               = 
  s.description           = "has_browser makes it possible to create simple, parameterized browser interfaces to your models."
  s.author                = "James Golick"
  s.email                 = 'james@giraffesoft.ca'
  s.homepage              = 'http://jamesgolick.com/'
  
  s.required_ruby_version = '>= 1.8.6'

  s.files                 = %w(MIT-LICENSE README Rakefile init.rb) +
                            Dir.glob("{lib,test,tasks}/**/*")
                              
  s.require_path          = "lib"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

task :tag_warn do
  puts "*" * 40
  puts "Don't forget to tag the release:"
  puts "  git tag -a v#{HasBrowser::Version::STRING}"
  puts "*" * 40
end
task :gem => :tag_warn

task :compile do
end

namespace :gem do
  namespace :upload do
    desc 'Upload gems to rubyforge.org'
    task :rubyforge => :gem do
      sh 'rubyforge login'
      sh "rubyforge add_release giraffesoft has_browser #{HasBrowser::Version::STRING} pkg/#{spec.full_name}.gem"
      sh "rubyforge add_file giraffesoft has_browser #{HasBrowser::Version::STRING} pkg/#{spec.full_name}.gem"
    end
  end
end

task :install => [:clobber, :compile, :package] do
  sh "sudo gem install pkg/#{spec.full_name}.gem"
end

task :uninstall => :clobber do
  sh "sudo gem uninstall #{spec.name}"
end
