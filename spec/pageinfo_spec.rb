require 'spec_helper'

describe Pageinfo do
  it 'has a version number' do
    expect(Pageinfo::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end

  subject { Pageinfo.new }

  describe "#process" do
    let(:input) { "My grandmom gave me a sweater for Christmas." }
    let(:output) { subject.process(input) }

    it 'converts to lowercase' do
      expect(output.downcase).to eq output
    end

    it 'combines nouns with doge adjectives' do
      expect(output).to match /so grandmom./i
      expect(output).to match /such sweater./i
      expect(output).to match /very christmas./i
    end

    it 'always appends "wow."' do
      expect(output).to end_with 'wow.'
    end
  end
end
