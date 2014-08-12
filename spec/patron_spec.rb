require 'library_spec_helper'

describe Patron do

  it 'instantiates a Patron class.' do
    test_patron = Patron.new({'name' => 'Dustin'})
    expect(test_patron).to be_an_instance_of Patron
  end

  it 'saves a Patron to the database' do
    test_patron = Patron.new({'name' => 'Dustin'})
    test_patron.save
    expect(Patron.all).to eq [test_patron]
  end

  it 'lists out the history of checkouts' do
    test_patron = Patron.new({'name' => 'Dustin'})
    test_patron.save
    test_book = Book.new({'name' => "Little Women"})
    test_author = Author.new({'name' => "Louisa May Alcott"})
    test_author.save
    test_book.add_author(test_author)
    test_book.save
    test_book.checkout(test_patron.id)
    expect(test_patron.history).to eq [test_book]
  end
end
