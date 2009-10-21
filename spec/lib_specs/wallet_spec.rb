require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Wallet do
  describe "Wallet::new" do
    it "should load the config on initialization if provided with a path to a yaml file" do
      YAML.should_receive(:load).once
      wallet = Wallet.new("channels:\n  adult_swim:")
      wallet.config.should_not == false
    end
    
    it "should not load the wallet.yml file on initialization if no file is provided" do
      YAML.should_receive(:load).once
      wallet = Wallet.new
      wallet.config.should be_empty
    end

    it "should set the default_ttl to 60 if no default_ttl: is provided in the config yml" do
      wallet = Wallet.new
      wallet.default_ttl.should == 60
    end

    it "should set the default_ttl to 300 if the default_ttl is set to 5.hours in the config yml" do
      wallet = Wallet.new "default_ttl: 5.hours"
      wallet.default_ttl.should == 5.hours.to_i
    end

    it "should set the default_ttl to 60 seconds if i make a mistake in my default_ttl entry in the config yml" do
      wallet = Wallet.new "default_ttl: 5.hurs"
      wallet.default_ttl.should == 60
    end
  end

  describe "Wallet::cached?" do
    before do
      config_yml = "channels:\n  cartoon_network:\n"
      @wallet = Wallet.new config_yml
    end

    it "should return true for a controller/action that is cached" do
      @wallet.cached?("channels", "cartoon_network").should == true
    end

    it "should return false for a controller/action that is not cached" do
      @wallet.cached?("blah", "blah").should == false
      @wallet.cached?("channels", "blah").should == false
    end

    it "should work with both strings and symbols" do
      @wallet.cached?("channels", "cartoon_network").should == true
      @wallet.cached?(:channels, :cartoon_network).should == true
    end
  end

  describe "Wallet::ttl" do
    before do
      config_yml = "channels:\n  cartoon_network: 5.minute\n  current_tv: "
      @wallet = Wallet.new config_yml
    end

    it "should return 5 minutes for the channels:cartoon_network ttl" do
      @wallet.ttl(:channels, :cartoon_network).should == 5.minutes.to_i
    end

    it "should return the default ttl for the current_tv action" do
      @wallet.ttl(:channels, :current_tv).should == @wallet.default_ttl
    end

    it "should raise a ActionNotCached error for the dne action" do
      proc {@wallet.ttl(:channels, :dne)}.should raise_error(Wallet::ActionNotCached)
    end
  end
end
