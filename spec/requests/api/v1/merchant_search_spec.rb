require 'rails_helper'
RSpec.describe 'Merchant API' do
  describe 'happy path' do
    it 'can fetch one merchant by id' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchant.count).to eq(1)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id].to_i).to eq(id)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe 'sad path' do
    it 'cannot find the merchant by id' do

      get "/api/v1/merchants/5048293"


      merchant = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response).to be_not_found
    end
  end
end
