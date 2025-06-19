# frozen_string_literal: true

require 'aranha/parsers/invalid_state_exception'
require 'aranha/temporary_errors_manager'

class NonTemporaryError < StandardError
end

RSpec.describe(Aranha::TemporaryErrorsManager) do
  describe '#temporary_error?' do
    {
      NonTemporaryError => false,
      Aranha::Parsers::InvalidStateException => true
    }.each do |error_class, expected_result|
      context "when error is a #{error_class}" do
        let(:error) { error_class.new('Any message') }

        it do
          expect(described_class.temporary_error?(error)).to eq(expected_result)
        end
      end
    end
  end
end
