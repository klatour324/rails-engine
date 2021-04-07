require 'rails_helper'

RSpec.describe 'Merchants with Most Revenue', type: :request do
  describe 'it returns a variable number of merchants ranked by total revenue' do
    before :each do
      seed_test_db
    end

    describe 'happy path' do
      it 'sends top ten merchants by revenue with a quantity of 10' do
        quantity = 10
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        returned_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(returned_json[:data].count).to eq(7)
        expect(returned_json[:data].first).to have_key(:id)
        expect(returned_json[:data].first[:id]).to be_a(String)
        expect(returned_json[:data].first[:id]).to eq(@merchant9.id.to_s)
        expect(returned_json[:data].first[:attributes]).to be_a(Hash)
        expect(returned_json[:data].first[:attributes]).to have_key(:revenue)
        expect(returned_json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(returned_json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(returned_json[:data].second[:attributes][:revenue]).to eq(10879.35)
      end

      it 'sends top merchant by revenue with a quantity of 1' do
        quantity = 1
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        returned_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(returned_json[:data].count).to eq(1)
        expect(returned_json[:data].first).to have_key(:id)
        expect(returned_json[:data].first[:id]).to be_a(String)
        expect(returned_json[:data].first[:id]).to eq(@merchant9.id.to_s)
        expect(returned_json[:data].first[:attributes]).to be_a(Hash)
        expect(returned_json[:data].first[:attributes]).to have_key(:revenue)
        expect(returned_json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(returned_json[:data].first[:attributes][:revenue]).to eq(11400.0)
      end

      it 'sends all 100 merchants if quantity is too large' do
        quantity = 100

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(7)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@merchant9.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(json[:data].last[:attributes][:revenue]).to eq(1.0)
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
        quantity = 'asdj'

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
