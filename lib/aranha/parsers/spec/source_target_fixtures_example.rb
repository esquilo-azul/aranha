# frozen_string_literal: true

require_relative 'source_target_fixtures'

RSpec.shared_examples 'source_target_fixtures' do |spec_file| # rubocop:disable Metrics/BlockLength
  let(:spec_file) { spec_file }

  it 'fixtures directory should exist' do
    expect(::File.directory?(fixtures_dir)).to be true
  end

  context 'in fixtures directory' do
    it 'should have at least one file' do
      expect(source_target_fixtures.source_target_files.count).to be > 0
    end

    if ENV['WRITE_TARGET_FIXTURES']
      it 'should write target data for all files' do
        source_target_fixtures.source_files.each do |source_file|
          sd = sort_results(source_data(source_file))
          basename = ::Aranha::Spec::SourceTargetFixtures.source_target_basename(source_file)
          target_file = File.expand_path("../#{basename}.target.yaml", source_file)
          File.write(target_file, sd.to_yaml)
        end
      end
    else
      it 'should parse data for all files' do
        source_target_fixtures.source_target_files.each do |st|
          assert_source_target_complete(st)
          sd = source_data(st.source)
          td = YAML.load_file(st.target)
          expect(sort_results(sd)).to eq(sort_results(td))
        end
      end
    end
  end

  def source_target_fixtures
    @source_target_fixtures ||= ::Aranha::Spec::SourceTargetFixtures.new(fixtures_dir)
  end

  def assert_source_target_complete(st)
    expect(st.source).to(be_truthy, "Source not found (Target: #{st.target})")
    expect(st.target).to(be_truthy, "Target not found (Source: #{st.source})")
  end

  def source_data(source_file)
    described_class.new(source_file).data
  end

  def fixtures_dir
    ::File.join(
      ::File.dirname(spec_file),
      ::File.basename(spec_file, '.*') + '_files'
    )
  end

  def sort_results(r)
    r
  end
end
