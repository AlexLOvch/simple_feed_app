require 'rails_helper'

RSpec.describe ApartmentsController, type: :controller do
  describe "GET index" do
    before do
      allow(controller).to receive(:render).and_call_original
    end

    it "render index w/ properly set data" do
      expect(Apartment).to receive(:with_topmost_agency)
      expect(subject).to receive(:render) do |options|
        expect(options[:locals][:apartments]).to eq([])
      end
      get :index
    end
  end
end
