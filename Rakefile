require 'rake/gempackagetask'
require 'rake/rdoctask'

runtime_deps   = {}
developer_deps = {}

spec = Gem::Specification.new { |s|
	s.platform = Gem::Platform::RUBY

	s.author = "Hemant Borole And Clarke Retzer"
	s.email = "hemantborole@gmail.com"
	s.files = Dir["{lib,configs,schema,bin}/**/*"].delete_if {|f|
		/\/rdoc(\/|$)/i.match f
	} + %w(Rakefile)
	s.require_path = 'lib'
	s.has_rdoc = true
	s.extra_rdoc_files = Dir['doc/*'].select(&File.method(:file?))
	s.extensions << 'ext/extconf.rb' if File.exist? 'ext/extconf.rb'
	Dir['bin/*'].map(&File.method(:basename)).map(&s.executables.method(:<<))

	s.name = 'omni_db'
	s.summary = "A plugin to transparently use a memory-based db and a persistent db at the same time."
  runtime_deps.each { | name, version | s.add_runtime_dependency( name.to_s, version ) }
  developer_deps.each { |name, version| s.add_development_dependency( name.to_s, version ) }
  
	s.version = '0.0.1'
}

Rake::RDocTask.new(:doc) { |t|
	t.main = 'doc/README'
	t.rdoc_files.include 'lib/**/*.rb', 'doc/*', 'bin/*', 'ext/**/*.c',
		'ext/**/*.rb'
	t.options << '-S' << '-N'
	t.rdoc_dir = 'doc/rdoc'
}

Rake::GemPackageTask.new(spec) { |pkg|
	pkg.need_tar_bz2 = true
}

task(:install => :package) {
	g = "pkg/#{spec.name}-#{spec.version}.gem"
	system "sudo jruby -S gem install -l #{g}"
}

desc "Run bacon test suite"
task :verify do
  #Change directory so correct config gets picked up
  Dir.chdir( File.join(File.dirname(__FILE__), "tests") )
  #Run test suite
  system("bacon test_*.rb")
end
