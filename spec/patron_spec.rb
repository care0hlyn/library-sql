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
end
