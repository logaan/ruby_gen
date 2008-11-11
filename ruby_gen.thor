# module: random

class RubyGen < Thor
  desc "app APPNAME", "generate a skeleton application using git and rpsec"
  def app(name)
    # Generate directory structure
    child_dirs = ["", "lib", "spec"].map{|dir| File.join(name, dir)}
    FileUtils.mkdir child_dirs

    # Write Rakefile
    File.open(File.join(name, "Rakefile"), "w+") { |file| file.write RAKEFILE }

    # Write spec.opts
    File.open(File.join(name, "spec", "spec.opts"), "w+") { |file| file.write SPECOPTS }

    # Write .gitignore
    File.open(File.join(name, ".gitignore"), "w+") { |file| file.write GITIGNORE }

    # Initialize git
    system("cd #{name}; git init")

    # Git add all
    system("cd #{name}; git add .")

    # git commit
    system("cd #{name}; git commit -m 'generated application skeleton'")
  end
end


RAKEFILE = <<-RAKEFILE
require 'rake'
require 'rake/clean'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

SPEC_FILES = FileList['spec/**/*.rb']

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = SPEC_FILES
  t.spec_opts = ["--colour --format progress"]
end

desc "Run all specs and display html report"
Spec::Rake::SpecTask.new('html_spec') do |t|
  t.spec_files = SPEC_FILES
  t.spec_opts = ["--format html"]
end

desc "Run all specs and generate RCov report"
Spec::Rake::SpecTask.new('cov') do |t|
  t.spec_files = SPEC_FILES
  t.spec_opts = ["--colour"]
  t.rcov = true
  t.rcov_opts = ['-T --no-html --exclude', 'spec\/,gems\/']
end

desc "Run all specs and generate HTML RCov report to coverage/index.html"
Spec::Rake::SpecTask.new('html_cov') do |t|
  t.spec_files = SPEC_FILES
  t.spec_opts = ["--colour"]
  t.rcov = true
  t.rcov_opts = ['-t --exclude', 'spec\/,gems\/']
end

desc "Run RDoc over the lib folder"
task :doc do
   system "rdoc --force-update --inline-source --line-numbers lib/"
end
RAKEFILE

SPECOPTS = <<-SPECOPTS
--colour
--format progress
--loadby mtime
--reverse
SPECOPTS

GITIGNORE = <<-GITIGNORE
.DS_Store
log/*
tmp/*
TAGS
*~
.#*
.hgignore
.hg/*
.svn/*
GITIGNORE

