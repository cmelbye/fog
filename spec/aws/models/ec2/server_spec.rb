require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/server_examples'

describe 'Fog::AWS::EC2::Server' do

  it_should_behave_like "Server"

  subject { @server = @servers.new(:image_id => GENTOO_AMI) }

  before(:each) do
    @servers = ec2.servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.wait_for { ready? }
      @server.destroy.should be_true
    end
  end

  describe "#initialize" do

    it "should remap attributes from parser" do
      server = @servers.new({
        'amiLaunchIndex'    => 'ami_launch_index',
        'dnsName'           => 'dns_name',
        'groupId'           => 'group_id',
        'imageId'           => 'image_id',
        'instanceId'        => 'instance_id',
        'instanceType'      => 'instance_type',
        'kernelId'          => 'kernel_id',
        'keyName'           => 'key_name',
        'launchTime'        => 'launch_time',
        'productCodes'      => 'product_codes',
        'privateDnsName'    => 'private_dns_name',
        'ramdiskId'         => 'ramdisk_id'
      })
      server.ami_launch_index.should == 'ami_launch_index'
      server.dns_name.should == 'dns_name'
      server.group_id.should == 'group_id'
      server.image_id.should == 'image_id'
      server.id.should == 'instance_id'
      server.flavor.should == 'instance_type'
      server.kernel_id.should == 'kernel_id'
      server.key_name.should == 'key_name'
      server.created_at.should == 'launch_time'
      server.product_codes.should == 'product_codes'
      server.private_dns_name.should == 'private_dns_name'
      server.ramdisk_id.should == 'ramdisk_id'
    end

  end

  describe "#addresses" do

    it "should return a Fog::AWS::EC2::Addresses" do
      subject.save
      subject.addresses.should be_a(Fog::AWS::EC2::Addresses)
    end

  end

  describe "#state" do
    it "should remap values out of hash" do
      server = Fog::AWS::EC2::Server.new({
        'instanceState' => { 'name' => 'instance_state' },
      })
      server.state.should == 'instance_state'
    end
  end

  describe "#key_pair" do
    it "should have tests"
  end

  describe "#key_pair=" do
    it "should have tests"
  end

  describe "#monitoring=" do
    it "should remap values out of hash" do
      server = Fog::AWS::EC2::Server.new({
        'monitoring' => { 'state' => true }
      })
      server.monitoring.should == true
    end
  end

  describe "#placement=" do

    it "should remap values into availability_zone" do
      server = Fog::AWS::EC2::Server.new({
        'placement' => { 'availabilityZone' => 'availability_zone' }
      })
      server.availability_zone.should == 'availability_zone'
    end

  end

  describe "#volumes" do

    it "should return a Fog::AWS::EC2::Volumes" do
      subject.save
      subject.volumes.should be_a(Fog::AWS::EC2::Volumes)
    end

  end

end
