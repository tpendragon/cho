# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::ChangeSetBehaviors do
  before(:all) do
    class MyCollection < Valkyrie::Resource
      include ::Collection::CommonFields
    end

    class MyCollectionChangeSet < Valkyrie::ChangeSet
      include ::Collection::ChangeSetBehaviors
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyCollection')
    ActiveSupport::Dependencies.remove_constant('MyCollectionChangeSet')
  end

  subject(:change_set) { MyCollectionChangeSet.new(MyCollection.new) }

  describe '#append_id' do
    before { change_set.append_id = Valkyrie::ID.new('test') }
    its(:append_id) { is_expected.to eq(Valkyrie::ID.new('test')) }
    its([:append_id]) { is_expected.to eq(Valkyrie::ID.new('test')) }
  end

  describe '#multiple?' do
    it 'has one title and description' do
      expect(change_set).not_to be_multiple(:workflow)
      expect(change_set).not_to be_multiple(:visibility)
    end
  end

  describe '#required?' do
    it 'has required fields' do
      expect(change_set).to be_required(:workflow)
      expect(change_set).to be_required(:visibility)
    end
  end

  describe '#fields=' do
    before { change_set.prepopulate! }
    its(:workflow) { is_expected.to be_nil }
    its(:visibility) { is_expected.to be_nil }
  end

  describe '#validate' do
    subject { change_set.errors }

    before { change_set.validate(params) }

    context 'without a title' do
      let(:params) { {} }

      its(:full_messages) { is_expected.to include("Title can't be blank") }
    end

    context 'with an unsupported workflow' do
      let(:params) { { title: 'title', workflow: 'foo' } }

      its(:full_messages) { is_expected.to include('Workflow is not included in the list') }
    end

    context 'with an unsupported visibility' do
      let(:params) { { title: 'title', visibility: 'foo' } }

      its(:full_messages) { is_expected.to include('Visibility is not included in the list') }
    end

    context 'with all required fields' do
      let(:params) { { title: 'Title', description: 'My collection', workflow: 'default', visibility: 'public' } }

      its(:full_messages) { is_expected.to be_empty }
    end
  end

  describe '#form_fields' do
    it 'contains all the fields from the collection schema' do
      expect(change_set.form_fields.map(&:label)).to contain_exactly('subtitle', 'description', 'title')
    end
  end

  describe '#input_fields' do
    let(:form) { double }

    it 'contains an array of Schema::InputFields' do
      expect(change_set.input_fields(form).map(&:label_text)).to contain_exactly('subtitle', 'description', 'title')
    end
  end
end
