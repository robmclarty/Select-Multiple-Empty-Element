# Rails Select Form Helper Multiple Option Issue

This is a simple Rails app demonstrating an issue I'm having where the Rails form
helper for making select tags, when set to be a "multi-select" element, adds an empty
hidden input tag to force the client to send something to the server in the case
that all options are deselected (thus, forcing the update_attributes to save the new
empty state of the model attribute). However this also seems to be sending an empty element
when options *are* selected as well. The specific issue I'm having is that this empty
element then gets saved through to the database and retrieved as a valid element of the
object's attributes, but containing no content.

I'm not 100% sure that I'm using the correct parameters on the select method, but it 
feels like something not entirely intentional is happening here, so I've made this
example to help illustrate the point and discuss the issue in more detail, hopefully
either shedding some light on how I'm using Rails, or pointing to a patch to account
for this issue in the Rails source code.

## App

This is a straight up scaffold-generated Rails 3.2.0.rc2 app with the following 
customizations for a model called `Thing` which has two attributes: `name` and `some_stuff`. 
The model has a constant called `ALL_STUFF` which is an array of all the possible
stuff that a `Thing` could have. Each `Thing` can, then, choose to have a sub-set of 
`ALL_STUFF` stored in its attribute `some_stuff`.

## Model

    class Thing < ActiveRecord::Base
      ALL_STUFF = %w{ Stuff1 Stuff2 Stuff3 Stuff4 Stuff5 }
      serialize :some_stuff
      validates_presence_of :name
    end
    
## Migration

    class CreateThings < ActiveRecord::Migration
      def change
        create_table :things do |t|
          t.string :name
          t.text :some_stuff
          t.timestamps
        end
      end
    end
    
## Show View

    <%= form_for(@thing) do |f| %>
      <% if @thing.errors.any? %>
        <div id="error_explanation">
          <h2><%= pluralize(@thing.errors.count, "error") %> prohibited this thing from being saved:</h2>
          <ul>
          <% @thing.errors.full_messages.each do |msg| %>
            <li><%= msg %></li>
          <% end %>
          </ul>
        </div>
      <% end %>

      <div class="field">
        <%= f.label :name %><br />
        <%= f.text_field :name %>
      </div>
      <div class="field">
        <%= f.label :some_stuff %><br />
        <%= f.select :some_stuff, Thing::ALL_STUFF, {}, :multiple => true, :selected => @thing.some_stuff %>
      </div>
      <div class="actions">
        <%= f.submit %>
      </div>
    <% end %>

## Database

The example app has a database which I've added some content to in order to view the issue.
You can see in the index view where `some_stuff` is listed, there is an empty element in the
first element of each array. I'm just looking for a way of handling that.