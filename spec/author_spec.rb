require 'library_spec_helper'

describe Author do

  it 'should initialize the name of the author' do
    test_author = Author.new({'name' => "JK Rowling"})
    expect(test_author).to be_an_instance_of Author
    expect(test_author.name).to eq "JK Rowling"
  end

  it 'should update the name of the author' do
    test_author = Author.new({'name' => "JK Rowling"})
    test_author.update_name('Isaac Asimov')
    expect(test_author.name).to eq 'Isaac Asimov'
  end

  it 'should save the author to the database' do
    test_author = Author.new({'name' => "JK Rowling"})
    test_author.save
    expect(Author.all).to eq [test_author]
    end

  it 'should delete the author from the database' do
    test_author = Author.new({'name' => "JK Rowling"})
    test_author.save
    expect(Author.all).to eq [test_author]
    test_author.delete
    expect(Author.all).to eq []
  end

end
