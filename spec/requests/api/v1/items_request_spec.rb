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

  it 'can create a new item' do
    merchant = create(:merchant)

    item_params = ({
                    name: 'GE Light Bulb',
                    description: 'Brightest light on the planet',
                    unit_price: 10.99,
                    merchant_id: merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
    returned_json = JSON.parse(response.body, symbolize_names: true)[:data]

  expect(response).to be_successful
  expect(response.status).to eq(201)
  expect(created_item.name).to eq(item_params[:name])
  expect(created_item.description).to eq(item_params[:description])
  expect(created_item.unit_price).to eq(item_params[:unit_price])
  expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  attributes = returned_json[:attributes]
  expect(attributes).to be_a(Hash)
  expect(attributes).to have_key(:name)
  expect(attributes[:name]).to be_a(String)
  expect(attributes).to have_key(:description)
  expect(attributes[:description]).to be_a(String)
  end

  describe 'sad path' do
    it 'does not create a record and returns an error if any attribute is missing' do
      merchant = create(:merchant)

      item_params = ({
                      description: 'Brightest light on the planet',
                      unit_price: 10.99,
                      merchant_id: merchant.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last
      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(406)
      expect(returned_json[:message]).to eq('Your query could not be completed')
      expect(returned_json[:errors].first).to eq("Name can't be blank")
    end

    it 'ignores any attributes that are not allowed' do
      merchant = create(:merchant)

      item_params = ({
                      name: 'GE Light Bulb',
                      description: 'Brightest light on the planet',
                      unit_price: 10.99,
                      merchant_id: merchant.id,
                      fav_food: 'Pizza'
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last
      returned_json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
      expect((returned_json).has_key?(:fav_food)).to eq(false)
      expect(response).to be_successful
      expect(response.status).to eq(201)
    end
  end

  it 'can update an existing item' do
    merchant = create(:merchant)
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'Lisa Frank Notebooks' }
    headers = {"CONTENT_TYPE" => "application/json" }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Lisa Frank Notebooks")
  end

  it 'cannot update an item whose id does not exist' do
    merchant = create(:merchant)
    item = create(:item)
    previous_name = Item.last.name
    item_params = { name: 'Lisa Frank Notebooks' }
    headers = {"CONTENT_TYPE" => "application/json" }

    patch "/api/v1/items/294856", headers: headers, params: JSON.generate({item: item_params})
    returned_json = JSON.parse(response.body, symbolize_names: true)[:data]
    item.reload

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(item.name).to eq(previous_name)
  end

  it 'cannot update an item that already exists with a bad merchant id' do
    merchant = create(:merchant)
    item = create(:item)
    item_params = { name: 'Lisa Frank Notebooks',
                    description: 'Colorful Furry Friend Notebooks',
                    unit_price: 9.99,
                    merchant_id: 93827472}
    headers = {"CONTENT_TYPE" => "application/json" }

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
    returned_json = JSON.parse(response.body, symbolize_names: true)[:data]
    item.reload

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it 'can destroy an item' do
    merchant = create(:merchant)
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
