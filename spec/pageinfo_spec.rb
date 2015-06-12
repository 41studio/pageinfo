require 'spec_helper'

describe Pageinfo do
  it 'has a version number' do
    expect(Pageinfo::VERSION).not_to be nil
  end

  it 'does something useful, inshaallah!' do
    expect(true).to eq(true)
  end

  describe "#detect" do
    let(:input) { "http://localhost:5000" }
    let(:output) { Pageinfo.detect(input) }

    it 'Detect all pages info on requested site' do
      expect(output.class).to eq(Fixnum)
    end
  end
end
