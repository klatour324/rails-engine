require 'rails_helper'

RSpec.describe 'Invoice Revenue', type: :request do
  describe 'sends total revenue for all invoices that are packaged' do
    before :each do
      seed_test_db
    end

    describe 'happy path' do
      it 'sends top invoices that have not been shipped' do
        get "/api/v1/revenue/unshipped"

        returned_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(returned_json[:data].count).to eq(10)
        expect(returned_json[:data].first).to have_key(:id)
        expect(returned_json[:data].first[:id]).to be_a(String)
        expect(returned_json[:data].first[:id]).to eq(@invoice6.id.to_s)
        expect(returned_json[:data].first[:attributes]).to be_a(Hash)
        expect(returned_json[:data].first[:attributes]).to have_key(:potential_revenue)
        expect(returned_json[:data].first[:attributes][:potential_revenue]).to be_a(Float)
        expect(returned_json[:data].first[:attributes][:potential_revenue]).to eq(20770.0)
        expect(returned_json[:data].second[:attributes][:potential_revenue]).to eq(4451.0)
      end

      it 'sends top one invoice by potential revenue' do
        quantity = 1
        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(1)
        expect(json[:data].first[:id]).to eq(@invoice6.id.to_s)
        expect(json[:data].first[:attributes]).to have_key(:potential_revenue)
        expect(json[:data].first[:attributes][:potential_revenue]).to eq(20770.0)
      end

      it ' sends all invoices if the quanity is too large' do
        quantity = 100

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(11)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@invoice6.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:potential_revenue)
        expect(json[:data].first[:attributes][:potential_revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:potential_revenue]).to eq(20770.0)
        expect(json[:data].last[:attributes][:potential_revenue]).to eq(101.0)
      end
    end

    describe 'sad path' do
      it 'sends an error response if the quantity is empty' do
        quantity = ''

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it 'sends an error response if the quantity is not an integer' do
        quantity = 'asdj'

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "sends an error response if the quantity is negative(less than 0)" do
        quantity = -1

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end
