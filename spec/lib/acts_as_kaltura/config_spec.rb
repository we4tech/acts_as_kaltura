require 'spec_helper'
require 'acts_as_kaltura'

describe ActsAsKaltura::Config do

  describe '.kaltura_configs' do
    before {
      Video._kaltura_config_file = Rails.root.join('spec', 'fixtures', 'kaltura.yml')
    }

    it 'should assign kaltura_configs class method' do
      Video.respond_to?('kaltura_configs').should be_true
    end

    it 'should return configuration as hash' do
      Video.kaltura_configs.should be_instance_of ActiveSupport::HashWithIndifferentAccess
    end

    describe 'loaded configuration' do
      subject { Video.kaltura_configs }

      it { subject['name'] == 'hasan@somewherein.net' }
      it { subject['partner_id'] == '819442' }
      it { subject['admin_secret'] == '175c396a37474df785be97968b652bce' }
    end
  end

  describe '.kaltura_client' do
    it 'should have kaltura_client method' do
      Video.respond_to?(:kaltura_client).should be_true
    end

    it 'should return kaltura client object' do
      Video.kaltura_client.should be_instance_of Kaltura::Client
    end
  end
end
