require 'spec_helper'
require 'acts_as_kaltura'

describe ActsAsKaltura::Category do

  describe '.acts_as_kaltura_category' do
    it 'should have acts_as_kaltura_category method' do
      Category.ancestors.should be_include(ActsAsKaltura::Category)
    end
  end

  describe '#create' do
    let!(:parent) { FactoryGirl.create(:category, :kaltura_category_key => '4107302') }

    it 'should create subcategory reference in kaltura' do
      lambda {
        FactoryGirl.create(:category, :parent => parent)
      }.should change(Category, :count).by 1
    end

    describe 'Created sub category' do
      subject { FactoryGirl.create(:category, :parent => parent) }
      its(:kaltura_category_key) { should be }
    end

    describe 'create multiple sub categories' do
      it 'should create hierarchical categories' do
        lambda { @first_cat = FactoryGirl.create(:category, :parent => parent) }.
            should change(Category, :count).by 1

        lambda { @second_cat = FactoryGirl.create(:category, :parent => @first_cat) }.
            should change(Category, :count).by 1

        lambda { @third_cat = FactoryGirl.create(:category, :parent => @second_cat) }.
            should change(Category, :count).by 1
      end
    end
  end

  describe '#update' do
    let!(:parent) { FactoryGirl.create(:category, :kaltura_category_key => '4107302') }

    it 'should update an existing category' do
      lambda {
        parent.update_attribute :name, 'Hola'
      }.should change(Category, :count).by(0)
    end

    describe 'updated category' do
      before { parent.update_attribute :name, 'Hola' }
      subject { parent }

      its(:name) { should == 'Hola' }
      its(:kaltura_category_key) { should be }
      its('kaltura_category.name') { should == 'Hola' }
    end
  end

  describe '#destroy' do
    let!(:parent) { FactoryGirl.create(:category, :kaltura_category_key => '4107302') }
    let!(:child) { FactoryGirl.create(:category, :parent => parent) }

    it 'should destroy category' do
      lambda {
        child.destroy
      }.should change(Category, :count).by(-1)
    end

    describe 'destroyed category' do
      before { child.destroy }

      it 'should throw api error' do
        lambda { child.kaltura_category }.
            should raise_error(Kaltura::APIError)
      end
    end
  end

  describe '#kaltura_category' do
    let!(:parent) { FactoryGirl.create(:category, :kaltura_category_key => '4107302') }
    subject { parent.kaltura_category }

    its(:id) { should == 4107302 }
  end

  describe '#kaltura_siblings' do
    let!(:parent) { FactoryGirl.create(:category, :kaltura_category_key => '4107302') }

    it 'should load all existing categories' do
      parent.kaltura_siblings.should be
    end

    describe 'siblings' do
      subject { parent.kaltura_siblings }
      it { should be_instance_of Kaltura::Response::CategoryListResponse }
    end
  end

  describe '.kaltura_parent_categories' do
    let!(:categories) { Category.kaltura_parent_categories }
    subject { categories }

    it { should be }
    it { subject.objects.map(&:parent_id).should == categories.total_count.times.map { 0 } }
  end
end