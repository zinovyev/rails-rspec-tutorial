require "rails_helper"

RSpec.describe "hello spec" do
  describe "math" do
    it "should be able to perform basic math" do
      # expect(6 * 7).to eq(43) # => false
      expect(6 * 7).to eq(42)
    end
  end

  describe String do
    let(:string) { String.new }
    it "should provide an empty string" do
      expect(string).to eq("")
    end
  end
end
