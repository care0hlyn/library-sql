require 'pry'

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

end
