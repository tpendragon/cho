# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataApplicationProfileCsvImporter do
  let(:header) { "Label,Field Type,Requirement Designation,Validation,Multiple,Controlled Vocabulary,Default Value,Display Name,Display Transformation\n" }
  let(:csv_field1) { "abc123_label,date,recommended,no_validation,false,abc123_vocab,abc123,My Abc123,abc123_transform\n" }

  let(:file) { StringIO.new(header + csv_field1) }

  let(:importer) { described_class.new(file) }

  it 'parses a file' do
    expect {
      importer.import
    }.to change(MetadataApplicationProfileField, :count).by(1)
  end

  context 'record exists' do
    let(:field) { create :metadata_application_profile_field }

    before do
      field
    end
    it 'will update records' do
      expect {
        importer.import
      }.to change(MetadataApplicationProfileField, :count).by(0)
    end
  end

  context 'no header line' do
    let(:file) { StringIO.new(csv_field1) }

    it 'uses the default' do
      expect {
        importer.import
      }.to change(MetadataApplicationProfileField, :count).by(1)
    end
  end
end
