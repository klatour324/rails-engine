require 'rails_helper'

RSpec.describe 'Find All Merchants' do
  describe 'happy path' do
    it 'finds all merchants which match a search term' do
      merchant1 = create(:merchant, name: 'Super Awesome Cakes')
      merchant2 = create(:merchant, name: 'Awesome Cakes')
      merchant3 = create(:merchant, name: 'Oh Wonderful Cakes')

      search_fragment = 'Awesome'

      get "/api/v1/merchants/find_all?name=#{search_fragment}"

      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(returned_json.count).to eq(1)
      expect(returned_json[:data][0]).to have_key(:id)
      expect(returned_json[:data][0][:id]).to be_a(String)
      expect(returned_json[:data][0][:id]).to eq(merchant2.id.to_s)
      expect(returned_json[:data][0][:attributes]).to be_a(Hash)
      expect(returned_json[:data][0][:attributes]).to have_key(:name)
      expect(returned_json[:data][0][:attributes][:name]).to be_a(String)
      expect(returned_json[:data][1][:attributes][:name]).to eq(merchant1.name)
      expect(returned_json[:data][1][:id]).to eq(merchant1.id.to_s)
    end
  end

  describe 'sad path' do
    it 'returns an empty collection if the searched for term does not exist' do
      fragment = 'fancy'

      get "/api/v1/merchants/find_all?name=#{fragment}"

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Array)
      expect(json[:data].empty?).to eq(true)
    end
  end
end
