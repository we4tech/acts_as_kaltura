require 'spec_helper'
require 'acts_as_kaltura'

describe ActsAsKaltura do

  describe '.acts_as_kaltura_video' do
    it 'should include KalturaApi::Video' do
      Video.ancestors.should be_include(ActsAsKaltura::Video)
    end

    [:video_file, :uploaded_video_token, :kaltura_token].each do |field|
      it "should add #{field} getter" do
        Video.new.respond_to?(field).should be_true
      end

      it "should add #{field} setter" do
        Video.new.respond_to?(:"#{field.to_s}=").should be_true
      end
    end

    [:process_uploaded_video_file,
     :update_kaltura_video_entry,
     :create_kaltura_video_entry].each do |method|
      it "should define #{method}" do
        Video.new.respond_to?(method, true).should be_true
      end
    end

    it "should invoke process and create filters" do
      video = FactoryGirl.build(:video)
      video.should_receive(:process_uploaded_video_file).and_return(true)
      video.should_receive(:create_kaltura_video_entry).and_return(true)

      lambda {
        video.save
      }.should change(Video, :count).by(1)
    end

    it "should invoke process and update filters" do
      video = FactoryGirl.create(:video)
      video.should_receive(:process_uploaded_video_file).and_return(true)
      video.should_receive(:update_kaltura_video_entry).and_return(true)

      lambda {
        video.update_attribute :title, 'hola'
      }.should change(Video, :count).by(0)
    end
  end
end
