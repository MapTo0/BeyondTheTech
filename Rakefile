require 'rspec/core/rake_task'

task :default => :run

task :run do
  ruby "app.rb"
end

task :test do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--colour --format documentation"
  end
  Rake::Task["spec"].execute
end

task :lint do
  sh 'rubocop'
end
