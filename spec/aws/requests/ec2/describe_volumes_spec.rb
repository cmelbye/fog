require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_volumes' do
  describe 'success' do

    before(:each) do
      @volume_id = ec2.create_volume('us-east-1a', 1).body['volumeId']
    end

    after(:each) do
      ec2.delete_volume(@volume_id)
    end

    it "should return proper attributes with no params" do
      actual = ec2.describe_volumes
      actual.body['requestId'].should be_a(String)
      volume = actual.body['volumeSet'].select {|volume| volume['volumeId'] == @volume_id}.first
      volume['availabilityZone'].should be_a(String)
      volume['createTime'].should be_a(Time)
      volume['size'].should == 1
      volume['snapshotId'].should == ''
      volume['status'].should be_a(String) 
      volume['volumeId'].should == @volume_id
      volume['attachmentSet'].should == []
    end

    it "should return proper attributes for specific volume" do
      actual = ec2.describe_volumes(@volume_id)
      actual.body['requestId'].should be_a(String)
      volume = actual.body['volumeSet'].select {|volume| volume['volumeId'] == @volume_id}.first
      volume['availabilityZone'].should be_a(String)
      volume['createTime'].should be_a(Time)
      volume['size'].should == 1
      volume['snapshotId'].should == ''
      volume['status'].should be_a(String) 
      volume['volumeId'].should == @volume_id
      volume['attachmentSet'].should == []
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if volume does not exist" do
      lambda {
        ec2.describe_volumes('vol-00000000')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
