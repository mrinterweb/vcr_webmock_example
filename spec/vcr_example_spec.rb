require 'spec_helper'

describe "VCR testing" do

  before :all do
    Excon.defaults[:mock] = true
  end

  let(:connection) do
    Excon.new('http://localhost:3001', headers: { 'Content-Type' => 'application/json' })
  end
  
  subject do
    connection.post path: '/activities/4', body: '{}'
  end

  context "with webmock stubs" do

    before do
      # VCR.turn_off! # does not seem to make a difference if VCR is disabled
      stub_request(:post, %r~localhost:3001/activities/.*~).to_return(body: [])
    end

    it "should work" do
      # this works about 60% of the time on my machine
      # The times that this spec fails, I get Excon::Errors::StubNotFound
      # If you keep running the spec over and over it should fail
      subject
    end

  end

  context "with excon stubs" do
    before do
      Excon.stub({path: /activities/}, { body: "[]", status: 200 })
    end

    it "should work" do
      subject
    end
  end

end
