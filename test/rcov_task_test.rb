require File.dirname(__FILE__) + '/test_helper'

begin
  require 'rake'
rescue LoadError
  require 'rubygems'
  require 'rake'
end

require 'rcov/rcovtask'

class TestRcovTask < Test::Unit::TestCase

  def test_opts_posix_shellquoted
    saved_rcovopts = ENV['RCOVOPTS']
    saved_rcovpath = ENV['RCOVPATH']
    saved_test = ENV['TEST']
    begin
      ENV.delete('RCOVOPTS')
      ENV['RCOVPATH'] = 'bin/rcov'
      ENV['TEST'] = 'foo.rb'
      t = Rcov::RcovTask.new(:rcovtask_test) do |t|
        t.ruby_opts << '-I/path/with spaces/lib'
        t.rcov_opts = [ '--exclude', %q!(\A|/)(test_.*|.*_spec)\.rb\Z! ]
        t.rcov_opts += [ '--diff-cmd', %q!O'Brian's Diff Tool! ]
      end
      assert_equal %q!'-I/path/with spaces/lib' '-Ilib' 'bin/rcov' '--exclude' '(\\A|/)(test_.*|.*_spec)\\.rb\\Z' '--diff-cmd' 'O'\\''Brian'\\''s Diff Tool' '-o' 'coverage' 'foo.rb'!,
        t.send(:shellquoted_ruby_args), "shell arguments should be quoted properly for POSIX shells"
    ensure
      ENV['RCOVPATH'] = saved_rcovpath if saved_rcovpath
      ENV['RCOVOPTS'] = saved_rcovopts if saved_rcovopts
      ENV['TEST'] = saved_test if saved_test
    end
  end
end
