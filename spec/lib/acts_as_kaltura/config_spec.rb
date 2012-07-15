require 'spec_helper'
require 'acts_as_kaltura'

describe ActsAsKaltura::Config do

  describe '.kaltura_configs' do
    before {
      Video._kaltura_config_file = Rails.root.join('spec', 'fixtures', 'kaltura.yml')
    }

    context 'with default configuration' do
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
  end

  describe '.kaltura_client' do
    context 'without company scoped setting' do
      it 'should have kaltura_client method' do
        Video.respond_to?(:kaltura_client).should be_true
      end

      it 'should return kaltura client object' do
        Video.kaltura_client.should be_instance_of Kaltura::Client
      end
    end

    context 'with company scoped setting' do
      let!(:video1) do
        FactoryGirl.create(
            :video_1,
            :company => FactoryGirl.build(
                :company_2,
                :setting => FactoryGirl.build(:setting_1)))
      end

      let!(:video2) do
        FactoryGirl.create(
            :video_1,
            :company => FactoryGirl.build(
                :company_2,
                :setting => FactoryGirl.build(:setting_2)))
      end

      describe 'instance kaltura_client' do
        subject { video1 }
        its(:kaltura_client) { should be }
      end

      describe 'video1' do
        subject { video1 }
        its('company.setting') { should be }
        its('company.setting.partner_id') { should be == '819442' }

        it 'should create kaltura client with the same partner id' do
          subject.kaltura_client.config.partner_id.should == '819442'
        end
      end

      describe 'video2' do
        subject { video2 }
        its('company.setting') { should be }
        its('company.setting.partner_id') { should be == '829252' }

        it 'should create kaltura client with the same partner id' do
          subject.kaltura_client.config.partner_id.should == '829252'
        end
      end

    end
  end
end
