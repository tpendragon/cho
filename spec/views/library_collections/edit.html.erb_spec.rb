# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collection/library_collections/edit', type: :view do
  let(:collection) { build(:library_collection, title: ['Editable title'], id: 'id') }
  let(:change_set) { Collection::LibraryChangeSet.new(collection) }

  before do
    @collection = assign(:collection, change_set)
    render
  end

  it 'renders the edit form' do
    assert_select 'form[action=?][method=?]', library_collection_path(@collection), 'post' do
      assert_select 'input[name=?]', 'library_collection[title]'
      assert_select 'input[name=?]', 'library_collection[subtitle]'
      assert_select 'textarea[name=?]', 'library_collection[description]'
      assert_select 'input[name=?]', 'library_collection[workflow]'
      assert_select 'input[name=?]', 'library_collection[visibility]'
      # Added to make sure accessibility changes are in place
      assert_select 'legend', 'Basic Metadata'
      assert_select 'label', /Title\s.* required/
      assert_select 'legend', 'Workflow'
      assert_select 'legend', 'Visibility'
    end
  end
end
