require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.delete_bucket' do
  describe 'success' do

    before(:each) do
      s3.put_bucket('fogdeletebucket')
    end

    it 'should return proper attributes' do
      actual = s3.delete_bucket('fogdeletebucket')
      actual.status.should == 204
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        s3.delete_bucket('fognotabucket')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a Conflict error if the bucket is not empty' do
      s3.put_bucket('fogdeletebucket')
      s3.put_object('fogdeletebucket', 'fog_delete_object', lorem_file)
      lambda {
        s3.delete_bucket('fogdeletebucket')
      }.should raise_error(Excon::Errors::Conflict)
      s3.delete_object('fogdeletebucket', 'fog_delete_object')
      s3.delete_bucket('fogdeletebucket')
    end

  end
end
