require 'spec_helper'
require 'acts_as_kaltura'

describe ActsAsKaltura::Extension do

  describe '#cuepoint_service' do
    it 'should be exposed from client' do
      service = Video.kaltura_client.cuepoint_service
      service.should be
    end

    describe ActsAsKaltura::Extension::Service::CuePointService do

      describe '#add' do
        let!(:user) { FactoryGirl.create(:user) }
        let!(:video) { FactoryGirl.create(:video, :user => user) }
        let!(:chapter) { FactoryGirl.create(:chapter, :end_time => 1.3, :user => user, :video => video) }

        it 'should set cuepoint_service' do
          Chapter.kaltura_client.cuepoint_service.should be
        end

        it 'should set cuepoint_key' do
          cuepoint = Chapter.new(video: video).kaltura_client.
              cuepoint_service.add( chapter.tap{|c| c.title = "Rand - #{rand}"}.as_annotation_cuepoint )
          cuepoint.should be
          cuepoint.should be_instance_of Kaltura::Annotation
        end
      end


      describe '#get' do
        let(:cuepoint) { Chapter.kaltura_client.cuepoint_service.get('0_ibrtqzuc') }
        subject { cuepoint }

        it { should be }
        its(:id) { should == '0_ibrtqzuc' }
        it { should be_instance_of Kaltura::Annotation }
      end

      describe '#count' do
        context 'without filter' do
          subject { Chapter.kaltura_client.cuepoint_service.count.to_i }
          it { should >= 10 }
        end

        context 'with filter' do
          let(:filter) {
            ActsAsKaltura::Extension::KalturaCuepointFilter.new.tap do |i|
              i.order_by = 'created_at'
            end
          }
          subject { Chapter.kaltura_client.cuepoint_service.count(filter).to_i }
          it { should >= 10 }
        end
      end

      describe '#update' do
        let!(:user) { FactoryGirl.create(:user) }
        let!(:video) { FactoryGirl.create(:video, :user => user) }
        let!(:chapter) { FactoryGirl.create(:chapter, :end_time => 1.3, :user => user, :video => video) }
        let!(:kaltura_cuepoint) do
          Chapter.new(video: video).kaltura_client.cuepoint_service.add( chapter.tap{|c| c.title = "Rand - #{rand}"}.as_annotation_cuepoint )
        end

        subject { Chapter.kaltura_client.cuepoint_service.
              update( kaltura_cuepoint.id, chapter.as_annotation_cuepoint ) }

        it { should be }
        it { subject.should be_instance_of Kaltura::Annotation }
      end

      describe '#list' do
        context 'without filter and pager' do
          let!(:response) { Chapter.kaltura_client.cuepoint_service.list }
          subject { response }

          it { should be }
          its(:total_count) { should >= 14 }
        end

        context 'with filter and pager' do
          let(:filter) {
            ActsAsKaltura::Extension::KalturaCuepointFilter.new.tap do |i|
              i.order_by = 'created_at'
            end
          }
          let(:pager) {
            Kaltura::FilterPager.new.tap {|i| i.page_size = 5 }
          }
          let!(:response) {
            Chapter.kaltura_client.cuepoint_service.list(filter, pager)
          }
          subject { response }

          it { should be }
          its('objects.size') { should == 5 }
        end
      end

      describe '#delete' do
        let!(:user) { FactoryGirl.create(:user) }
        let!(:video) { FactoryGirl.create(:video, :user => user) }
        let!(:chapter) { FactoryGirl.create(:chapter, :end_time => 1.3, :user => user, :video => video) }

        it 'should delete an existing cuepoint' do
          r = Chapter.kaltura_client.cuepoint_service.delete(chapter.cuepoint_key)
          stub_request(:post, "http://www.kaltura.com/api_v3/index.php?action=get&service=cuepoint_cuepoint").
              to_return(:status => 200, :body => %{<?xml version="1.0" encoding="utf-8"?><xml><result><error><code>INVALID_CUE_POINT_ID</code><message>Invalid cue point id [0_6sjizlby]</message></error></result><executionTime>0.063361883163452</executionTime></xml>})
          lambda { Chapter.kaltura_client.cuepoint_service.get(chapter.cuepoint_key) }.
              should raise_error(Kaltura::APIError)
        end
      end
    end

    describe ActsAsKaltura::Extension::KalturaAnnotation do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:video) { FactoryGirl.create(:video, :user => user) }
      let!(:chapter) { FactoryGirl.create(:chapter, :user => user, :video => video) }
      subject { chapter.as_annotation_cuepoint }

      it { should be_instance_of ActsAsKaltura::Extension::KalturaAnnotation }
      its(:cue_point_type) { should be }
      its(:start_time) { should be }
      its(:end_time) { should be }
      its(:system_name) { should be }
      its(:text) { should be }
      its(:entry_id) { should be }
    end

  end
end