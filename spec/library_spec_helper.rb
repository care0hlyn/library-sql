require 'book'
require 'author'
require 'rspec'
require 'pg'

DB = PG.connect({:dbname => 'library'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM authors_books *;")
    DB.exec("DELETE FROM copies *;")
  end
end
