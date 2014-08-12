require 'book'
require 'author'
require 'patron'
require 'rspec'
require 'pg'
require 'chronic'

DB = PG.connect({:dbname => 'library'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM authors_books *;")
    DB.exec("DELETE FROM copies *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM checkouts *;")
  end
end
