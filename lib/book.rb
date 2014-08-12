require 'pry'

class Book

  attr_reader :name, :id, :authors

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id'].to_i
    @authors = attributes['authors']
    if @authors == nil
      @authors = []
    end
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
    @authors << author
    DB.exec("INSERT INTO authors_books (author_id, book_id) VALUES (#{author.id}, #{@id});")
  end

end
