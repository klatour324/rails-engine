# Rails Engine

## About this Project
Rails Engine is a Rails E-Commerce Application that focuses on a service-oriented structure, where data is exposed to the front end through an API. The purpose of this project is to learn how to test and expose an API, use serializers to format JSON responses and further the understanding of advance ActiveRecord queries in order to analyze information stored in the database.  

## Table of Contents

  - [Getting Started](#getting-started)
  - [Running the tests](#running-the-tests)
  - [Database Schema](#database-schema)
  - [Application Code](#application-code)
  - [Built With](#built-with)
  - [Contributing](#contributing)
  - [Versioning](#versioning)
  - [Author](#author)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)

## Getting Started

To get the web application running, please fork and clone down the repo.
`git clone <your@github.account/rails-engine>`

### Prerequisites

To run this application you will need Ruby 2.5.3 and Rails 5.2.5

### Installing

- Install the gem packages  
`bundle install`

- Download a copy of the data locally
 https://raw.githubusercontent.com/turingschool/backend-curriculum-site/gh-pages/module3/projects/rails_engine/rails-engine-development.pgdump

- Create the database by running the following command in your terminal
`rails db{:drop, :create, :migrate}`

## Running the tests
RSpec testing suite is utilized for testing this application.
- Run the RSpec suite to ensure everything is passing as expected  
`bundle exec rspec`

## Database Schema
The schema represents the relationships between the models in the database. The schema includes the following six tables:
  - Merchants
  - Items
  - Customers
  - Invoices
  - Invoice-Items
  - Transactions

Merchants and Items exhibit a one-to-many relationship, where a merchant has many items, and many items belong to a merchant

Items and Invoices have a many-to-many relationship through the joins table Invoice-Items

Customers and Invoices have a one-to-many relationship a customer can have many invoices and many invoices belong to a customer

Transactions also exhibits a one-to-many relationship where an invoice can have many transactions and transactions belong to an invoice

## Endpoints
### Merchants
- `GET /api/v1/merchants`
  - Retrieve all merchants

- `GET /api/v1/merchants?per_page={number}&page={number}`
  - Retrieve a specific page of merchants with a desired number per page

- `GET /api/v1/merchant/:id`
  - This pattern allows the user to fetch a single merchant record based on the merchant's id

- `GET /api/v1/merchants/:id/items`
  - Return all items associated with a merchant based on the specified merchant id

### Search Merchants
- `GET /api/vi/merchants/find_all?name={name}`
  - Retrieve merchants searched by name fragment and returned in alphabetical order

### Items
- `GET /api/v1/items`
  - Fetch all items

- `GET /api/v1/items?per_page={number}&page={number}`
  - Retrieve a specific page of items with a desired number per page

- `GET /api/v1/items/:id`
  - This pattern allows the user to fetch a single item record based on the item's id

- `POST /api/v1/items`
  - Allows a user to create a new item

- `PUT /api/v1/items/:id`
  - Allows a user to update a specific item based on its id

- `DELETE /api/v1/items/:id`
  - Allows a user to delete and item and an invoice in which the item is associated with if it is the only item that exists on that invoice

- `GET /api/v1/items/:id/merchant`
  - Returns the merchant associated with an item based on the item's id

### Search Items
- `GET /api/v1/items/find_one?name={name}`
  - Finds a single item that matches a search term and accounts for fragmented searches

- `GET /api/v1/items/find?min_price={number}`
  - Retrieve one item with a price that is greater than or equal to the min_price

- `GET /api/v1/items/find?max_price={number}`
  - Retrieve one item with a price that is less than or equal to the max_price

- `GET /api/v1/items/find?min_price={number}&max_price={number}`
  - Retrieve a single item with a price that is greater than or equal to the min_price and greater than or equal to the max_price

### Business Logic
- `GET /api/v1/merchants/most_revenue?quantity=x`
  - Retrieve a variable number(`x`) of merchants ranked by total revenue where `x` is the number of merchants to be returned

- `GET /api/v1/revenue/merchants/:id`
  - Retrieves the total revenue for a single merchant

- `GET /api/v1/revenue/unshipped?quantity=x`
  - Retrieves the potential revenue of unshipped orders that are ranked by their potential revenue. This endpoint will allow a user to see how much money is being left on the table for these merchants if left unshipped. `x` in this case is the maximum count of results to return

- `GET /api/v1/items/revenue?quantity=x`
  - Retrieves a quantity of items ranked by revenue in descending order, where `x` represents the maximum count of results to return

## Built With
- Ruby
- Rails
- RSpec
- FactoryBot
- Faker

## Versioning
- Ruby 2.5.3
- Rails 5.2.5

## Author
- **Katy La Tour**
     | [GitHub](https://github.com/klatour324) |
    [LinkedIn](https://www.linkedin.com/in/klatour324/)
