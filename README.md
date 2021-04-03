# Rails Engine

## About this Project
Rails Engine is a Rails E-Commerce Application that focuses on a service-oriented structure, where data is exposed to the front end through an API. The purpose of this project is to learn how to test and expose an API, use serializers to format JSON responses and further the understanding of advance ActiveRecord queries in order to analyze information stored in the SQL database.  

## Summary

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

## Application code
This application code utilizes MVC principles along with the Facade Design Pattern.

## Built With
- Ruby
- Rails
- RSpec
- FactoryBot
- Faker

## Contributing

## Versioning
- Ruby 2.5.3
- Rails 5.2.5

## Author
- **Katy La Tour**
     | [GitHub](https://github.com/klatour324) |
    [LinkedIn](https://www.linkedin.com/in/klatour324/)

## Licensing

## Acknowledgements
