require 'rails_helper'

RSpec.describe 'Items with Most Revenue', type: :request do
  describe 'it returns a quantity of items ranked by descending revenue' do
    before :each do
      seed_test_db
    end

    describe 'happy path' do
      it 'sends top items by revenue' do

        get "/api/v1/revenue/items"

        returned_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(returned_json[:data].count).to eq(10)
        expect(returned_json[:data].first).to have_key(:id)
        expect(returned_json[:data].first[:id]).to be_a(String)
        expect(returned_json[:data].first[:id]).to eq(@item11.id.to_s)
        expect(returned_json[:data].first[:attributes]).to be_a(Hash)
        expect(returned_json[:data].first[:attributes]).to have_key(:revenue)
        expect(returned_json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(returned_json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(returned_json[:data].second[:attributes][:revenue]).to eq(8550.0)
      end

      it 'sends top item by revenue with a quantity of 1' do
        quantity = 1

        get "/api/v1/revenue/items?quantity=#{quantity}"

        returned_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(returned_json[:data].count).to eq(1)
        expect(returned_json[:data].first).to have_key(:id)
        expect(returned_json[:data].first[:id]).to be_a(String)
        expect(returned_json[:data].first[:id]).to eq(@item11.id.to_s)
        expect(returned_json[:data].first[:attributes]).to be_a(Hash)
        expect(returned_json[:data].first[:attributes]).to have_key(:revenue)
        expect(returned_json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(returned_json[:data].first[:attributes][:revenue]).to eq(11400.0)
      end

      it 'sends all 1000000 items if quantity is too large' do
        quantity = 1000000

        get "/api/v1/revenue/items?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(12)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@item11.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(json[:data].last[:attributes][:revenue]).to eq(0.0)
      end
    end

    describe 'sad path' do
      it 'sends an error response if the quantity is empty' do
        quantity = ''

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it 'sends an error response if the quantity is not an integer' do
        quantity = 'afhadkhg'

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sends an error response if the quantity is negative(less than 0)" do
        quantity = -1

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sends an error response if the quantity is missing" do

        get "/api/v1/revenue/merchants?quantity="

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end
