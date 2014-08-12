require 'pry'
require 'chronic'

class Book

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id'].to_i
  end

  def authors
    results = DB.exec("SELECT * FROM authors;")
    authors = []
    results.each do |author|
      authors << Author.new(author)
    end
    authors
  end

  def self.all
    results = DB.exec("SELECT * FROM books;")
    books = []
    results.each do |book|
      books << Book.new(book)
    end
    books
  end

  def save
    results = DB.exec("INSERT INTO books (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
    DB.exec("INSERT INTO copies (book_id, total_copies) VALUES (#{@id}, 1);")
  end

  def ==(another_book)
    self.name == another_book.name && self.id == another_book.id
  end

  def update_name(new_name)
    @name = new_name
    DB.exec("UPDATE books SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{@id};")
  end

  def add_author(author)
    # @authors << author
    DB.exec("INSERT INTO authors_books (author_id, book_id) VALUES (#{author.id}, #{@id});")
  end

  def self.search_author(author)
    output_books = []
    book_results = DB.exec("SELECT books.* FROM authors
      join authors_books on (authors.id = authors_books.author_id)
      join books on (authors_books.book_id = books.id)
      WHERE authors.id = #{author.id};")
    book_results.each do |book|
      output_books << Book.new(book)
    end
    output_books
  end

  def self.search_title(title)
    output_books = []
    book_results = DB.exec("SELECT * FROM books WHERE name = '#{title}';")
    book_results.each do |book|
      output_books << Book.new(book)
    end
    output_books
  end

  def add_copies(how_many)
    total_copies = how_many + self.get_copies
    DB.exec("UPDATE copies SET total_copies = #{total_copies} WHERE book_id = #{@id};")
  end

  def get_copies
    results = DB.exec("SELECT total_copies FROM copies WHERE book_id = #{@id};")
    total_copies = results.first['total_copies'].to_i
  end

  def checkout(patron_id)
    due_date = Chronic.parse('next week').to_i
    formatted_due_date = Time.at(due_date).to_s.split(" ")[0]
    results = DB.exec("INSERT INTO checkouts (patron_id, book_id, due_date) VALUES (#{patron_id}, #{@id}, '#{due_date}');")
    self.add_copies(-1)
  end

  def self.get_checked_out
    checked_book = []
    book_results = DB.exec("SELECT * FROM checkouts JOIN books ON (books.id = checkouts.book_id);")
    book_results.each do |book|
      checked_book << Book.new(book)
    end
    checked_book
  end

end




































