# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Curated, type: :feature do
  context 'when filling in all the required fields' do
    it 'creates a new curated collection' do
      visit(new_curated_collection_path)
      fill_in('curated_collection[title]', with: 'New Title')
      fill_in('curated_collection[subtitle]', with: 'new subtitle')
      fill_in('curated_collection[description]', with: 'Description of new collection')
      choose('Mediated')
      choose('Authenticated')
      click_button('Create Curated collection')
      expect(page).to have_content('New Title')
      expect(page).to have_content('new subtitle')
      expect(page).to have_content('Description of new collection')
      expect(page).to have_content('mediated')
      expect(page).to have_content('authenticated')
    end
  end

  context 'without providing the required metadata' do
    it 'reports the errors' do
      visit(new_curated_collection_path)
      click_button('Create Curated collection')
      expect(page).to have_content("Title can't be blank")
    end
  end
end
