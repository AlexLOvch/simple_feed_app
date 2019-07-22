# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loadable do
  let(:validate_data) { false }
  let(:convert_to_attr_hash) { false }
  let(:dummy_class) { Class.new {} }

  describe '.load_data' do
    it 'adds load_data method' do
      expect(dummy_class.respond_to?('load_data')).to be false
      dummy_class.include(Loadable)
      expect(dummy_class.respond_to?('load_data')).to be true
    end

    context 'when loadable with from present' do
      let(:from_url) { 'http://sample.com/source.yaml' }
      let(:validate_data) { false }
      let(:convert_to_attr_hash) { false }
      let(:response_data) { "---\n- field1: \"field1_data_row1\"\n  field2: \"field2_data_row1\"\n- field1: \"field1_data_row2\"\n  field2: \"field2_data_row2\"" }
      let(:expected_data) { [{ 'field1' => 'field1_data_row1', 'field2' => 'field2_data_row1' }, { 'field1' => 'field1_data_row2', 'field2' => 'field2_data_row2' }] }
      let(:dummy_loadable_class) do
        Class.new(OpenStruct) do
          include Loadable
          attr_accessor :field1, :field2

          def valid?
          end

          def errors
          end

          def self.column_names
            %w[field1 field2]
          end                                                                                                                                              end
        end
      end
      before do
        stub_request(:get, from_url).to_return(body: response_data)
        dummy_loadable_class.loadable(from: from_url, validate_data: validate_data, convert_to_attr_hash: convert_to_attr_hash)
      end

      it 'requests url while load data' do
        dummy_loadable_class.load_data
        expect(WebMock).to have_requested(:get, from_url)
      end

      it 'parsed yaml' do
        expect(dummy_loadable_class.load_data).to eq expected_data
      end

      context 'when validation present' do
        let(:validate_data) { true }
        let(:expected_data) do
          [
            dummy_loadable_class.new('field1' => 'field1_data_row1', 'field2' => 'field2_data_row1'),
            dummy_loadable_class.new('field1' => 'field1_data_row2', 'field2' => 'field2_data_row2')
          ]
        end

        it 'validates data and returns all if valid' do
          allow_any_instance_of(dummy_loadable_class).to receive(:valid?).and_return(true)
          expect(dummy_loadable_class.load_data).to eq expected_data
        end

        it 'validates data, returns nothing and log errors if all records are invalid' do
          allow_any_instance_of(dummy_loadable_class).to receive(:valid?).and_return(false)
          allow_any_instance_of(dummy_loadable_class).to receive(:errors).and_return(OpenStruct.new(full_messages: 'Error messages'))
          expect(Rails.logger).to receive(:error).with(/Error messages/)
          expect(dummy_loadable_class.load_data).to eq []
        end
      end

      context 'when convert_to_attr_hash present' do
        let(:validate_data) { true }
        let(:convert_to_attr_hash) { true }
        let(:response_data) { "---\nfield1_data_row1: field2_data_row1\nfield1_data_row2: field2_data_row2\n" }
        let(:expected_data) do
          [
            dummy_loadable_class.new('field1' => 'field1_data_row1', 'field2' => 'field2_data_row1'),
            dummy_loadable_class.new('field1' => 'field1_data_row2', 'field2' => 'field2_data_row2')
          ]
        end

        it 'converts data properly' do
          allow_any_instance_of(dummy_loadable_class).to receive(:valid?).and_return(true)
          expect(dummy_loadable_class.load_data).to eq expected_data
        end
      end

      context 'when downloading is unsuccessful' do
        it 'logs an errors' do
          allow(Loader).to receive(:load).and_raise('BOOOM!')
          expect(Rails.logger).to receive(:error).with(/BOOOM!/)
          dummy_loadable_class.load_data
        end
      end
    end
  end

  describe '.load!' do
    let(:from_url) { 'http://sample.com/source.yaml' }
    let(:response_data) { "---\n- field1: \"field1_data_row1\"\n  field2: \"field2_data_row1\"\n" }
    let(:dummy_loadable_class) { Class.new(OpenStruct) { include Loadable; attr_accessor :field1, :field2; def valid?; end; def errors; end; def save; end; def self.destroy_all; end } }
    before do
      stub_request(:get, from_url).to_return(body: response_data)
      dummy_loadable_class.loadable(from: from_url, validate_data: true)
    end

    context 'when data downloaded successfully' do
      it 'deletes existent data'  do
        allow_any_instance_of(dummy_loadable_class).to receive(:valid?).and_return(true)
        expect(dummy_loadable_class).to receive(:destroy_all)
        dummy_loadable_class.load!
      end

      it 'saves downloaded data' do
        allow_any_instance_of(dummy_loadable_class).to receive(:valid?).and_return(true)
        expect_any_instance_of(dummy_loadable_class).to receive(:save)
        dummy_loadable_class.load!
      end
    end

    context 'when downloaded data are empty' do
      it 'does not delete existent data' do
        allow_any_instance_of(dummy_loadable_class).to receive(:valid?).and_return(false)
        expect(dummy_loadable_class).to_not receive(:destroy_all)
        dummy_loadable_class.load!
      end
    end
  end
end
