require 'library_spec_helper'

describe Book do
  it 'should initalize the name of the book' do
    test_book = Book.new({'name' => "Little Women"})
    expect(test_book).to be_an_instance_of Book
    expect(test_book.name).to eq "Little Women"
  end

  it 'should save the book to the database' do
    test_book = Book.new({'name' => "Little Women"})
    test_book.save
    expect(Book.all).to eq [test_book]
  end
end
