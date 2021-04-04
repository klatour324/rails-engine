require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'happy path' do
    it 'sends a list of up to 20 items when items per_page is not specified' do
      create_list(:item, 50)

      get '/api/v1/items'

      items = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(items[:data].count).to eq(20)

      item = items[:data].first
      attributes = item[:attributes]
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(attributes).to be_a(Hash)
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
    end

    it 'can send a list of items up to 20 per page where first 20 on page 1 match the first 20 items in the DB' do
      create_list(:item, 21)

      get '/api/v1/items?page=1'

      items = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(items[:data].count).to eq(20)
      expect(items[:data][1][:id].to_i).to eq(items[:data][0][:id].to_i + 1)
      expect(items[:data][19][:id].to_i).to eq(items[:data][0][:id].to_i + 19)
    end

    it 'sends a unique list of up to 20 items per page where the page results do not repeat' do
      create_list(:item, 41)

      get '/api/v1/items?page=1'

      items1 = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(items1[:data].count).to eq(20)
      expect(items1[:data][1][:id].to_i).to eq(items1[:data][0][:id].to_i + 1)
      expect(items1[:data][19][:id].to_i).to eq(items1[:data][0][:id].to_i + 19)

      get '/api/v1/items?page=2'

      items2 = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(items2[:data].count).to eq(20)
      expect(items2[:data][0][:id].to_i).to eq(items1[:data][0][:id].to_i + 20)
      expect(items2[:data][-1][:id].to_i).to eq(items2[:data][0][:id].to_i + 19)
    end

    describe 'sad path' do
      it 'can send page 1 if the page specified is 0 or less' do
        create_list(:item, 21)

        get '/api/v1/items?page=0'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(items[:data].count).to eq(20)
        expect(items[:data][1][:id].to_i).to eq(items[:data][0][:id].to_i + 1)
        expect(items[:data][19][:id].to_i).to eq(items[:data][0][:id].to_i + 19)
      end
    end
  end
end
