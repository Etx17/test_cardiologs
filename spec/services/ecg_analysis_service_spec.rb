require 'rails_helper'

RSpec.describe EcgAnalysisService do
  let(:csv_file) { fixture_file_upload('spec/fixtures/records.csv', 'text/csv') }
  let(:empty_csv_file) { fixture_file_upload('spec/fixtures/empty.csv', 'text/csv') }
  let(:measurement_datetime) { Time.current.to_s }
  let(:min_heart_rate_limit) { 30 }
  let(:max_heart_rate_limit) { 250 }
  let(:ecg_analysis_service) { EcgAnalysisService.new(csv_file, measurement_datetime, min_heart_rate_limit, max_heart_rate_limit ) }
  let(:results) { ecg_analysis_service.analyze }
  let(:empty_ecg_analysis_service) { EcgAnalysisService.new(empty_csv_file, measurement_datetime, min_heart_rate_limit, max_heart_rate_limit ) }
  let(:wrong_order_ecg_analysis_service) { EcgAnalysisService.new(fixture_file_upload('spec/fixtures/records_with_wrong_order.csv', 'text/csv'), measurement_datetime, min_heart_rate_limit, max_heart_rate_limit ) }
  context 'when required arguments are not provided' do
    it 'does not instantiate' do
      expect { EcgAnalysisService.new }.to raise_error(ArgumentError)
    end
  end

  context 'when required arguments are provided' do

    it 'instantiates correctly with valid data' do
      expect(ecg_analysis_service).to be_an_instance_of(EcgAnalysisService)
    end

    it 'responds to analyze' do
      expect(ecg_analysis_service).to respond_to(:analyze)
    end

    it 'counts the correct numbers of QRS' do
      expect(results[:qrs_count]).to eq(68)
    end

    it 'calculates correct mean heart rate' do
      expect(results[:mean_heart_rate]).to eq(53.23871472306025)
    end

    it 'calculates correct min heart rate' do
      expect(results[:min_heart_rate]).to eq(53.191489361702125)
    end

    it 'calculates correct max heart rate' do
      expect(results[:max_heart_rate]).to eq(53.285968028419184)
    end

    it 'raises an error if csv file is empty' do
      expect { empty_ecg_analysis_service.analyze }.to raise_error(ArgumentError)
    end

    it 'raises an error if a current QRS time is before the previous QRS time' do

      expect { wrong_order_ecg_analysis_service.analyze }.to raise_error(ArgumentError)
    end

    it 'takes into account if unusual value (range set by cardiologist) is present in the csv file as artefact' do
      expect(results[:noise_count]).to eq(64)
    end
  end
end
