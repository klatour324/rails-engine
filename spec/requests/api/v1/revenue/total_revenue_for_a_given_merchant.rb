require 'rails_helper'

RSpec.describe 'Total Revenue for a Given Merchant', type: :request do
  before :each do
    seed_test_db
  end

  describe 'happy path' do
    it 'returns the total revenue for a given merchant id' do

      get "/api/v1/revenue/merchants/#{Merchant.last.id}"

      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(returned_json[:data][:id]).to eq(Merchant.last.id.to_s)
      expect(returned_json[:data][:attributes][:revenue]).to eq("335.0")
    end
  end

  describe 'sad path' do
    it 'returns a error response if a bad merchant id is given' do

      get "/api/v1/revenue/merchants/44444444444"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end
