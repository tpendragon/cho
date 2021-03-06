# frozen_string_literal: true

RSpec.shared_examples 'a collection with works' do
  before do
    (1..20).each do |count|
      create(:work, title: "Work #{count}", member_of_collection_ids: [collection.id])
    end
  end

  it 'displays a paginated listing of its works' do
    visit(polymorphic_path([:solr_document], id: collection.id))
    expect(page).to have_content('Items in this Collection')
    within('div#members') do
      expect(page).to have_link('Work 1')
      expect(page).not_to have_link('Work 20')
    end
    within('div.pagination') do
      expect(page).to have_link('2')
      click_link('Next')
    end
    within('div#members') do
      expect(page).not_to have_link('Work 5')
      expect(page).to have_link('Work 20')
    end
  end
end

RSpec.shared_examples 'a collection' do
  describe '#title' do
    it 'is nil when not set' do
      expect(resource_klass.new.title).to be_empty
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(title: 'test')
      expect(resource.attributes[:title]).to contain_exactly('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:title)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:title)
    end
  end

  describe '#members' do
    subject { resource_klass.new(new_record: false) }

    its(:members) { is_expected.to be_empty }
  end
end
