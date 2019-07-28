# frozen_string_literal: true

require 'aranha/parsers/source_address'

RSpec.describe ::Aranha::Parsers::SourceAddress do
  describe '#detect_sub' do
    {
      { method: :post, url: 'http://postdata.net', params: { key1: :value1 } } => {
        klass: ::Aranha::Parsers::SourceAddress::HashHttpPost,
        url: 'http://postdata.net',
        serialization: <<SERIALIZATION
--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess
method: :post
url: http://postdata.net
params: !ruby/hash:ActiveSupport::HashWithIndifferentAccess
  key1: :value1
SERIALIZATION
      },
      'http://postdata.net' => {
        klass: ::Aranha::Parsers::SourceAddress::HttpGet,
        url: 'http://postdata.net',
        serialization: 'http://postdata.net'
      },
      'https://getdata.com.br' => {
        klass: ::Aranha::Parsers::SourceAddress::HttpGet,
        url: 'https://getdata.com.br',
        serialization: 'https://getdata.com.br'
      },
      'file:///postdata.net' => {
        klass: ::Aranha::Parsers::SourceAddress::File,
        url: 'file:///postdata.net',
        serialization: 'file:///postdata.net'
      },
      '/postdata.net' => {
        klass: ::Aranha::Parsers::SourceAddress::File,
        url: 'file:///postdata.net',
        serialization: 'file:///postdata.net'
      }
    }.each do |source, expected|
      context "when source is #{source}" do
        let(:sub) { described_class.detect_sub(source) }
        let(:deserialized) { described_class.deserialize(sub.serialize).sub }

        it "sub is a #{expected.fetch(:klass)}" do
          expect(sub).to be_a(expected.fetch(:klass))
        end

        it "sub #{expected.fetch(:klass)} return properly URL" do
          expect(sub.url).to eq(expected.fetch(:url))
        end

        it "sub #{expected.fetch(:klass)} serialize properly" do
          expect(sub.serialize).to eq(expected.fetch(:serialization))
        end

        it 'deserialize properly' do
          expect(deserialized).to eq(sub)
        end
      end
    end
  end
end
