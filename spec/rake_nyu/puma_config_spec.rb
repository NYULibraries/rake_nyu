require 'spec_helper'
module RakeNyu
  describe PumaConfig, "#initialize" do
    it "returns correct settings based on config" do
      puma_config = PumaConfig.new('9292')
      puma_config.port.should eq('9292')
      puma_config.bind.should eq('tcp://127.0.0.1:9292')
      puma_config.pid.should eq('/Users/dalton/Documents/workspace/rake_nyu/spec/dummy/tmp/pids/puma-9292.pid"')
      puma_config.log.should eq('/Users/dalton/Documents/workspace/rake_nyu/spec/dummy/log/puma-test-9292.log')
      puma_config.scripts_path.should eq('/Users/dalton/Documents/workspace/rake_nyu/spec/dummy/config/deploy/puma')
    end
  end
end