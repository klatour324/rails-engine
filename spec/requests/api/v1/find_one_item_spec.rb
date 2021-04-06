require 'rails_helper'

RSpec.describe 'Find One Item' do
  describe 'happy path' do
    it 'finds a single item which matches a search term' do
      item1 = create(:item, name: 'Super Awesome Cakes')
      item2 = create(:item, name: 'Awesome Cakes')
      item3 = create(:item, name: 'The Most Awesome Cakes')

      search_fragment = 'awesome'

      get "/api/v1/items/find?name=#{search_fragment}"

      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(returned_json.count).to eq(1)
      expect(returned_json[:data]).to have_key(:id)
      expect(returned_json[:data][:id]).to be_a(String)
      expect(returned_json[:data][:attributes]).to be_a(Hash)
      expect(returned_json[:data][:attributes]).to have_key(:name)
      expect(returned_json[:data][:attributes][:name]).to be_a(String)
      expect(returned_json[:data][:attributes][:name]).to eq(item2.name)
      expect(returned_json[:data][:attributes]).to have_key(:description)
      expect(returned_json[:data][:attributes][:description]).to be_a(String)
      expect(returned_json[:data][:attributes]).to have_key(:unit_price)
      expect(returned_json[:data][:attributes][:unit_price]).to be_a(Float)
      expect(returned_json[:data][:attributes]).to have_key(:merchant_id)
      expect(returned_json[:data][:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  describe 'sad path' do
    it 'returns an empty collection if nothing exists' do
      fragment = 'awesome'

      get "/api/v1/items/find?name=#{fragment}"

      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(returned_json.count).to eq(1)
      expect(returned_json[:data]).to be_a(Hash)
    end
  end

end
