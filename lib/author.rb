class Author

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id'].to_i
  end

  def update_name(name)
    DB.exec("UPDATE authors SET name = '#{@name}';")
    @name = name
  end

  def save
    results = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM authors;")
    authors = []
    results.each do |author_info|
      authors << Author.new(author_info)
    end
    authors
  end

  def ==(another_author)
    another_author.name == self.name && another_author.id == self.id
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{@id};")
  end

end
