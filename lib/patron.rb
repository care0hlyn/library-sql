require 'pry'
require 'chronic'

class Patron

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id'].to_i
  end

  def save
    results = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    patrons = []
    results = DB.exec("SELECT * FROM patrons;")
    results.each do |patron|
      patrons << Patron.new(patron)
    end
    patrons
  end

  def ==(another_patron)
    self.name == another_patron.name && self.id == another_patron.id
  end

  def history
    book_results = []
    results = DB.exec("SELECT books.*
      FROM books JOIN checkouts
      ON (books.id = checkouts.book_id)
      WHERE (checkouts.patron_id = #{@id});")
    results.each do |book|
      book_results << Book.new(book)
    end
    book_results
  end

  def get_checked_out
    due_date = ""
    currently_checkedout_books = {}

    results = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{@id};")
    results.each do |checkout|
      book_id = checkout['book_id']
      due_date = checkout['due_date']
      books = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      books.each do |book|
        current_book = Book.new(book)
        currently_checkedout_books[current_book.name] = Time.at(due_date.to_i).to_s.split(" ")[0]
      end
    end

    currently_checkedout_books
  end

end
