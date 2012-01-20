class Thing < ActiveRecord::Base
  ALL_STUFF = %w{ Stuff1 Stuff2 Stuff3 Stuff4 Stuff5 }
  serialize :some_stuff
  validates_presence_of :name
end
