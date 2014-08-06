require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

Rake::TestTask.new(:"test:unit") do |t|
  t.pattern = "test/unit/**/*_test.rb"
end

Rake::TestTask.new(:"test:integration") do |t|
  t.pattern = "test/integration/**/*_test.rb"
end

task default: :test
