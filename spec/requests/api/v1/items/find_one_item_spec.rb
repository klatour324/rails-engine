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

    it "fetches one item by min price sorted alphabetically" do
      item1 = create(:item, name: "B Item", unit_price: 30.99)
      item2 = create(:item, name: "A Item", unit_price: 20.99)
      item3 = create(:item, name: "C Item", unit_price: 10.99)
      min_price = 18.99

      get "/api/v1/items/find?min_price=#{min_price}"

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data][:id]).to_not eq(item1.id.to_s)
      expect(json[:data][:id]).to eq(item2.id.to_s)
      expect(json[:data][:attributes][:name]).to eq(item2.name)
    end

    it "fetches one item by max price sorted alphabetically" do
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      max_price = 200.00

      get "/api/v1/items/find?max_price=#{max_price}"

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data][:id]).to_not eq(item1.id.to_s)
      expect(json[:data][:id]).to eq(item2.id.to_s)
      expect(json[:data][:attributes][:name]).to eq(item2.name)
    end

    it "returns 200 but no data if min price is too big" do
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      min_price = 1000.00

      get "/api/v1/items/find?min_price=#{min_price}"

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Hash)
      expect(json[:data].empty?).to eq(true)
    end

    it "returns 200 but no data if max price is not met" do
      item1 = create(:item, name: "B Item", unit_price: 100.99)
      item2 = create(:item, name: "A Item", unit_price: 99.99)
      item3 = create(:item, name: "C Item", unit_price: 300.99)
      max_price = 1.00

      get "/api/v1/items/find?max_price=#{max_price}"

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Hash)
      expect(json[:data].empty?).to eq(true)
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

    it "gives a 400 error response if both name and min_price are given" do
      get "/api/v1/items/find?name=cool&min_price=100"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "gives a 400 error response if both name and max_price are given" do
      get "/api/v1/items/find?name=cool&max_price=100"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "gives a 400 error response if the max_price is less than min_price" do
      get "/api/v1/items/find?min_price=100&max_price=10"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "gives a 400 error response if the min_price is negative (less than 0)" do
      get "/api/v1/items/find?min_price=-1"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "gives a 400 error response if the max price is negative (less than 0)" do
      get "/api/v1/items/find?max_price=-1"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "gives a 400 error response if nothing is passed in" do
      get "/api/v1/items/find?444444444"
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
