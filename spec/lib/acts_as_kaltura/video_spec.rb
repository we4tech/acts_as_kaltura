require 'spec_helper'
require 'acts_as_kaltura'

describe Video do
  context 'validations' do
    it { should validate_presence_of :video_file }
  end
end

describe ActsAsKaltura::Video do

  describe '#process_uploaded_video_file' do
    let!(:video) { Factory.build(:video) }
    let!(:video_no_video_file) { Factory.build(:video, :video_file => nil) }

    it 'should set uploaded video kaltura reference' do
      video.save
      p video.uploaded_video_token
      video.uploaded_video_token.should be
    end
  end

  describe '#create_kaltura_video_entry' do
    let!(:video) { Factory.build(:video) }

    it 'should create kaltura video entry' do
      lambda { video.save }.should change(Video, :count).by(1)
      p video.kaltura_key
      video.reload.kaltura_key.should be
      video.reload.kaltura_syncd_at.should be
    end
  end

  describe '#update_kaltura_video_entry' do
    context 'when no new video file added' do
      let!(:video) { Factory(:video) }

      it 'should update existing kaltura video entry' do
        lambda {
          video.video_file  = nil
          video.title       = 'Oita kida'
          video.description = 'Eita description'
          video.save
        }.should change(Video, :count).by(0)

        video.reload.title.should == 'Oita kida'
        video.reload.description.should == 'Eita description'
      end
    end

    context 'when new video file added' do
      let!(:video) { Factory(:video) }

      it 'should update existing kaltura video entry' do
        lambda {
          video.video_file  = File.open(Rails.root.join('spec', 'fixtures', 'movie2.m4v'))
          video.title       = '2 Oita kida'
          video.description = '2 Eita description'
          video.save
        }.should change(Video, :count).by(0)

        video.reload.title.should == '2 Oita kida'
        video.reload.description.should == '2 Eita description'
      end
    end
  end

  describe '#destroy_kaltura_video_entry' do

    context 'test on mock object' do
      let!(:video) { Factory(:video) }

      it 'should invoke destroy_kaltura_video_entry' do
        video.should_receive(:destroy_kaltura_video_entry).and_return(true)
        video.destroy
      end
    end

    context 'with kaltura video' do
      let!(:video) { Factory(:video) }
      before do
        stub_request(:post, 'http://www.kaltura.com/api_v3/index.php?service=media&action=get').
            to_return(:body => %{<?xml version="1.0" encoding="utf-8"?><xml><result><error><code>ENTRY_ID_NOT_FOUND</code><message>Entry id "0_zg72qm1n" not found</message></error></result><executionTime>0.039528846740723</executionTime></xml>})
      end

      it 'should delete video' do
        lambda {
          video.destroy
        }.should change(Video, :count).by(-1)
      end

      it 'should delete kaltura entry' do
        video.destroy
        lambda { video.kaltura_entry }.should raise_error(Kaltura::APIError)
      end
    end
  end

  describe '#video with company association' do

    context 'test video created with out company' do
      let!(:video) {Factory(:video)}

      it 'should have company' do
        video.company.should be
      end

      it 'should have company setting' do
        video.company.setting.login.should == "hasan@somewherein.net"
      end
    end

    context 'test video created with company' do
      let!(:video) {Factory(:video_1, :company => Factory(:company_1, :setting => Factory(:setting_1)))}

      it 'should have company' do
        video.company.should be
      end

      it 'should have company setting' do
        video.company.setting.should be
      end
    end
  end

end
