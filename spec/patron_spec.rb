require 'library_spec_helper'

describe Patron do

  it 'instantiates a Patron class.' do
    test_patron = Patron.new({'name' => 'Dustin'})
    expect(test_patron).to be_an_instance_of Patron
  end
end
