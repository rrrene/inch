require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
  t.warning = false
end

Rake::TestTask.new(:"test:unit") do |t|
  t.pattern = 'test/unit/**/*_test.rb'
  t.warning = false
end

Rake::TestTask.new(:"test:elixir") do |t|
  t.pattern = 'test/unit/language/elixir/**/*_test.rb'
  t.warning = false
end

Rake::TestTask.new(:"test:ruby") do |t|
  t.pattern = 'test/unit/language/ruby/**/*_test.rb'
  t.warning = false
end

Rake::TestTask.new(:"test:integration") do |t|
  t.pattern = 'test/integration/**/*_test.rb'
  t.warning = false
end

task default: :test
