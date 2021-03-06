# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metrics::Work do
  let(:metric)    { described_class.new(length: 1, output: report) }
  let(:report)    { StringIO.new }
  let(:work)      { ::Work::Submission.all.first }
  let(:file_uri)  { URI(Work::File.find(work.files.first).file_identifier.to_s) }

  describe '#file_size' do
    subject { metric }

    context 'by default' do
      its(:file_size) { is_expected.to eq(50) }
    end

    context 'when set' do
      before { metric.file_size = 1 }
      its(:file_size) { is_expected.to eq(1) }
    end
  end

  it 'creates a work with a 1 MB file and benchmarks the results' do
    metric.file_size = 1
    metric.run
    header, results = report.string.split("\n")
    expect(header).to eq(' User,System,Total,Real')
    expect(results.split(',').count).to eq(4)
    expect(File.stat(file_uri.path).size).to eq(1048576)
  end
end
