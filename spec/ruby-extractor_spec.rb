# encoding: UTF-8

require 'spec_helper'

include Rosette::Extractors

describe RubyExtractor::FastGettextExtractor do
  let(:extractor) do
    RubyExtractor::FastGettextExtractor.new
  end

  FIXTURE_MANIFEST[:'fast-gettext'].each_pair do |expected_file, expected_phrases|
    it "extracts phrases correctly from #{expected_file}" do
      source_file = File.join(FIXTURE_DIR, expected_file)

      extractor.extract_each_from(File.read(source_file)).each do |actual_phrase, line_number|
        expected_phrase_index = expected_phrases.find_index { |phrase| phrase['key'] == actual_phrase.key }
        expected_phrase = expected_phrases[expected_phrase_index]
        expect(expected_phrase).to_not be_nil
        expect(expected_phrase['line_number']).to eq (line_number)
        expected_phrases.delete_at(expected_phrase_index)
      end

      expect(expected_phrases).to be_empty
    end
  end
end
