require 'rails_helper'

RSpec.describe 'Total Revenue for a Given Merchant', type: :request do
  before :each do
    seed_test_db
  end

  describe 'happy path' do
    it 'returns the total revenue for a given merchant id' do

      get "/api/v1/revenue/merchants/#{@merchant10.id}"

      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(returned_json[:data].count).to eq(3)
      expect(returned_json[:data]).to have_key(:id)
      expect(returned_json[:data][:id]).to be_a(String)
      expect(returned_json[:data][:id]).to eq(@merchant10.id.to_s)
      expect(returned_json[:data][:attributes]).to be_a(Hash)
      expect(returned_json[:data][:attributes]).to have_key(:revenue)
      expect(returned_json[:data][:attributes][:revenue]).to be_a(Float)
      expect(returned_json[:data][:attributes][:revenue]).to eq(373.45)
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
