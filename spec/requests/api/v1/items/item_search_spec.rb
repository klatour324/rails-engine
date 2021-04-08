require 'rails_helper'
RSpec.describe 'Item API' do
  describe 'happy path' do
    it 'can fetch one item by id' do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(item.count).to eq(1)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id].to_i).to eq(id)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe 'sad path' do
    it 'cannot find the item by id' do

      get "/api/v1/items/5048293"


      item = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(response).to be_not_found
    end
  end
end
