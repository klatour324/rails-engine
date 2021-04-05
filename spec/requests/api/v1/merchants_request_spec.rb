require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'happy path' do
    it 'sends a list of up to 20 merchants when merchants per_page is not specified' do
      create_list(:merchant, 50)

      get '/api/v1/merchants'

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchants[:data].count).to eq(20)

      merchant = merchants[:data].first
      attributes = merchant[:attributes]
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(attributes).to be_a(Hash)
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end

    it 'can send a list of merchants up to 20 per page where first 20 on page 1 match the first 20 merchants in the DB' do
      create_list(:merchant, 21)

      get '/api/v1/merchants?page=1'

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchants[:data].count).to eq(20)
      expect(merchants[:data][1][:id].to_i).to eq(merchants[:data][0][:id].to_i + 1)
      expect(merchants[:data][19][:id].to_i).to eq(merchants[:data][0][:id].to_i + 19)
    end

    it 'sends a unique list of up to 20 merchants per page where the page results do not repeat' do
      create_list(:merchant, 41)

      get '/api/v1/merchants?page=1'

      merchants1 = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchants1[:data].count).to eq(20)
      expect(merchants1[:data][1][:id].to_i).to eq(merchants1[:data][0][:id].to_i + 1)
      expect(merchants1[:data][19][:id].to_i).to eq(merchants1[:data][0][:id].to_i + 19)

      get '/api/v1/merchants?page=2'

      merchants2 = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchants2[:data].count).to eq(20)
      expect(merchants2[:data][0][:id].to_i).to eq(merchants1[:data][0][:id].to_i + 20)
      expect(merchants2[:data][-1][:id].to_i).to eq(merchants2[:data][0][:id].to_i + 19)
    end
  end

  describe 'sad path' do
    it 'can send page 1 if the page specified is 0 or less' do
      create_list(:merchant, 21)

      get '/api/v1/merchants?page=0'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(merchants[:data].count).to eq(20)
      expect(merchants[:data][1][:id].to_i).to eq(merchants[:data][0][:id].to_i + 1)
      expect(merchants[:data][19][:id].to_i).to eq(merchants[:data][0][:id].to_i + 19)
    end
  end

  describe 'happy path' do
    it 'can return all of the items requested when a merchant id is given' do
      merchant = create(:merchant)
      item1 = create(:item)
      item2 = create(:item)
      merchant.items << [item1, item2]

      get "/api/v1/merchants/#{merchant.id}/items"

      returned_json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(returned_json[:data].count).to eq(2)

      expect(returned_json[:data][0][:id]).to eq(item1.id.to_s)
      expect(returned_json[:data][0][:attributes]).to be_a(Hash)
      expect(returned_json[:data][0][:attributes]).to have_key(:name)
      expect(returned_json[:data][0][:attributes][:name]).to be_a(String)
      expect(returned_json[:data][0][:attributes][:description]).to be_a(String)
      expect(returned_json[:data][0][:attributes][:unit_price]).to be_a(Float)
      expect(returned_json[:data][0][:attributes]).to have_key(:merchant_id)
      expect(returned_json[:data][0][:attributes][:merchant_id]).to be_an(Integer)
    end
  end
end
