require 'spec_helper'

describe ActsAsKaltura::Annotation do

  describe '.acts_as_annotation' do
    it 'should add acts_as_annotation method' do
      Chapter.ancestors.should be_include(ActsAsKaltura::Annotation)
    end

    describe '#save_kaltura_annotation' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:video) { FactoryGirl.create(:video, :user => user) }
      let!(:chapter) { FactoryGirl.create(:chapter, :video => video, :user => user) }
      subject { chapter }

      its(:cuepoint_key) { should be }
      its(:kaltura_annotation) { should be }
      its(:kaltura_annotation) { should be_instance_of Kaltura::Annotation }
    end

    describe '#update_kaltura_annotation' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:video) { FactoryGirl.create(:video, :user => user) }
      let!(:chapter) { FactoryGirl.create(:chapter, :video => video, :user => user) }

      it 'should invoke update_kaltura_annotation' do
        chapter.should_receive(:update_kaltura_annotation).and_return(true)
        chapter.update_attributes :title => 'hola'
      end

      context 'when updates in kaltura instance' do
        before { chapter.update_attributes :title       => 'hi hi',
                                           :description => 'hola hola' }
        subject { chapter.kaltura_annotation }
        its(:system_name) { should == 'hi hi' }
        its(:text) { should == 'hola hola' }
      end
    end

    describe '#delete_kaltura_annotation' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:video) { FactoryGirl.create(:video, :user => user) }
      let!(:chapter) { FactoryGirl.create(:chapter, :video => video, :user => user) }

      it 'should invoke update_kaltura_annotation' do
        chapter.should_receive(:delete_kaltura_annotation).and_return(true)
        chapter.destroy
      end

      it 'should destroy chapter' do
        lambda {
          chapter.destroy
        }.should change(Chapter, :count).by(-1)
      end

      it 'should destroy remote instance' do
        chapter.destroy
        stub_request(:post, "http://www.kaltura.com/api_v3/index.php?action=get&service=cuepoint_cuepoint").
            to_return(:status => 200, :body => %{<?xml version="1.0" encoding="utf-8"?><xml><result><error><code>INVALID_CUE_POINT_ID</code><message>Invalid cue point id [0_6sjizlby]</message></error></result><executionTime>0.063361883163452</executionTime></xml>})
        lambda {
          chapter.kaltura_annotation
        }.should raise_error(Kaltura::APIError)
      end
    end
  end
end
