require 'spec_helper'
require 'acts_as_kaltura'

describe ActsAsKaltura::Delegator do

  context 'when created' do
    describe '.delegates_kaltura_attributes' do
      let!(:video) { Factory(:video) }

      it 'should have nil thumbnail attribute' do
        video.read_attribute(:thumbnail_url).should be_nil
      end

      it 'should invoke kaltura entry and update' do
        mock_entry = mock(Kaltura::MediaEntry)
        mock_entry.stub(:thumbnail_url => 'http://abc.thumbna.il')
        video.should_receive(:kaltura_entry).and_return(mock_entry)
        video.should_receive(:update_column)
          .with(:thumbnail_url, 'http://abc.thumbna.il')
          .and_return(true)
        video.thumbnail_url.should be
      end

      it 'should return thumbnail_url' do
        video.thumbnail_url.should be
        video.reload.read_attribute(:thumbnail_url).should be
      end

    end
  end

  context 'when updated' do
    describe '.delegates_kaltura_attributes' do
      let!(:video) { Factory(:video) }
      before {
        video.title = 'Test'
        video.save
      }

      it 'should set attribute as nil' do
        video.reload.read_attribute(:thumbnail_url).should be_nil
      end
    end
  end
end