SimpleCov.start do
  add_filter '/test/'

  add_group 'CLI', 'lib/inch/cli'
  add_group 'Code Objects', 'lib/inch/code_object'
  add_group 'Evaluation', 'lib/inch/evaluation'
end
