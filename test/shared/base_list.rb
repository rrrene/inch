module Shared
  module BaseList
    extend Minitest::Spec::DSL

    it 'should give error when run with --unknown-switch' do
      _out, _err = capture_io do
        assert_raises(SystemExit) do
          @command.run('lib/foo.rb', '--unknown-switch')
        end
      end
    end

    it 'should run with --depth switch' do
      out, err = capture_io do
        @command.run('lib/foo.rb', '--depth=2')
      end
      refute out.empty?, 'there should be some output'
      assert err.empty?, 'there should be no errors'
      assert_match(/\bFoo\b/, out)
      assert_match(/\bFoo::Bar\b/, out)
      refute_match(/\bFoo::Bar#method_with_full_doc\b/, out)
      refute_match(/\bFoo::Bar#method_with_code_example\b/, out)
    end

    it 'should run with --only-namespaces switch' do
      out, err = capture_io do
        @command.run('lib/foo.rb', '--only-namespaces')
      end
      refute out.empty?, 'there should be some output'
      assert err.empty?, 'there should be no errors'
      assert_match(/\bFoo\s/, out)
      assert_match(/\bFoo::Bar\s/, out)
      refute_match(/\bFoo::Bar\./, out)
      refute_match(/\bFoo::Bar#/, out)
    end

    it 'should run with --no-namespaces switch' do
      out, err = capture_io do
        @command.run('lib/foo.rb', '--no-namespaces')
      end
      refute out.empty?, 'there should be some output'
      assert err.empty?, 'there should be no errors'
      refute_match(/\bFoo\s/, out)
      refute_match(/\bFoo::Bar\s/, out)
      assert_match(/\bFoo::Bar#/, out)
    end

    it 'should run with --only-undocumented switch' do
      skip
      out, err = capture_io do
        @command.run('lib/foo.rb', '--all', '--only-undocumented')
      end
      refute out.empty?, 'there should be some output'
      assert err.empty?, 'there should be no errors'
      refute_match(/\bFoo\s/, out)
      refute_match(/\bFoo::Bar#method_with_full_doc\b/, out)
      assert_match(/\bFoo::Bar\s/, out)
      assert_match(/\bFoo::Bar#method_without_doc\b/, out)
    end

    it 'should run with --no-undocumented switch' do
      skip
      out, err = capture_io do
        @command.run('lib/foo.rb', '--all', '--no-undocumented')
      end
      refute out.empty?, 'there should be some output'
      assert err.empty?, 'there should be no errors'
      assert_match(/\bFoo\s/, out)
      assert_match(/\bFoo::Bar#method_with_full_doc\b/, out)
      refute_match(/\bFoo::Bar\s/, out)
      refute_match(/\bFoo::Bar#method_without_doc\b/, out)
    end
  end
end
