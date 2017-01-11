# Using ActiveAdmin as a backend in Rails 5 application

## Preparations

I will be using:
- Ruby 2.4.0
- Rails 5 with API key enabled
- SQLite
- ActiveAdmin


Preparing application:

1. Create a folder for application:
    ```Bash
    mkdir rails5_api_activeadmin 
    cd rails5_api_activeadmin
    ```

    [<img src="/public/img/1.png" alt="Creating folder" height=150 width=100 />](/public/img/1.png)

2. Create Gemset for application and install rails gem
    ```Bash
    rvm use 2.4.0@rails5_api_activeadmin --ruby-version --create
    gem install rails
    ```
    
    [<img src="/public/img/2.png" alt="Gemset created" height=150 width=100 />](/public/img/2.png)
    
3. Initialize a new git repository and generate a blank Rails 5 application
    ```Bash
    git init 
    rails new . --api
    ```
    
    [<img src="/public/img/3.png" alt="Git and Rails" height=150 width=100 />](/public/img/3.png)
    
4. Rails installed

    [<img src="/public/img/4.png" alt="Rails installed" height=150 width=100 />](/public/img/4.png)
    
5. Adding IDE settings folder to .gitignore and committing changes

    [<img src="/public/img/5.png" alt="Gitignore" height=150 width=100 />](/public/img/5.png)
    [<img src="/public/img/6.png" alt="Initial commit" height=150 width=100 />](/public/img/6.png)
    
6. Now launch a server and check if it's working (I am launching it on port 3080, but the default is 3000)
    ```
    rails s -p 3080
    ```
    
    [<img src="/public/img/7.png" alt="Default rails root" height=150 width=100 />](/public/img/7.png)
    

## Database Models
This application will be used as a service for ordering food from local restaurants. So we need to have a few database models:
 - Dish (title, type, ingredients, description, price)
 - Restaurant (title, description)
 
 
1. Scaffolding restaurant model

    I will use built in Rails scaffold generator and define fields, that have to be created at a database, providing field type.
    The default type is string, so it can be skipped. The model Dish will belong to model Restaurant and Restaurant 
    can have many dishes. Also, I will use Enumerable on a dish type field.
    
    ```
    rails g scaffold Restaurant title description
    rails g scaffold Dish title dish_type:integer ingredients description price:decimal restaurant:belongs_to
    ```
    
    [<img src="/public/img/8.png" alt="Models generated" height=150 width=100 />](/public/img/8.png)
    
    We can ignore warnings in this case (rails code is not updated to the changes in Ruby 2.4.0).
    
    And I used rails trick to tell, that model dish belongs to model Restaurant.
    
    [<img src="/public/img/9.png" alt="Generated models code" height=150 width=100 />](/public/img/9.png)
    
    Now I have to tell that Restaurant have many dishes and set dishes type.
    
    ```Ruby
    class Restaurant < ApplicationRecord
      has_many :dishes
    end
    ```
    
    ```Ruby
    class Dish < ApplicationRecord
      belongs_to :restaurant
      enum type: [:european, :pan_asian, :wok, :non_alcohol_drink, :alcohol_drink]
    end
    ```
    
    [<img src="/public/img/10.png" alt="Models code" height=150 width=100 />](/public/img/10.png)
    
    
    Enum will provide our application with automatically generated methods for dish type. And it will be saved in database
    as an integer starting with `0` where each next number will correspond to a dish type. 
    For example: `0 for european`, `1 for pan asian`, `2 for wok` etc.
    
2. Migrating Database, configuring controllers and creating test data

    Now I have to migrate the database and create dummy data
    ```Bash
    rails db:migrate
    rails c
    ```
    
    ```Ruby
    Restaurant.create(title: 'First Restaurant', description: "It's first")
    restaurant = Restaurant.first
    restaurant.dishes.burger.create(title: 'Country Burger', ingredients: "beef steak, goat cheese, red pepper, salad, 
                                    onion, Italian balsamic glaze, olive oil, brioche bread bun, salt, pepper", 
                                    description: 'Great burger', price: 2.99)
    ```
    
    [<img src="/public/img/11.png" alt="Migrating Datbase" height=150 width=100 />](/public/img/11.png)
    [<img src="/public/img/12.png" alt="Creating Restaurant" height=150 width=100 />](/public/img/12.png)
    [<img src="/public/img/13.png" alt="Creating dish" height=150 width=100 />](/public/img/13.png)
    
    Now if I visit `http://localhost:3080/restaurants` or `http://localhost:3080/dishes`, I will see data, stored in DB, 
    in JSON format
    
    [<img src="/public/img/14.png" alt="Restaurants" height=150 width=100 />](/public/img/14.png)
    [<img src="/public/img/15.png" alt="Dishes" height=150 width=100 />](/public/img/15.png)
    
    But I want to see all dishes, that restaurant have on its page and restaurant name on a dishes page, so I have to make 
    some changes to corresponding controllers.
    
    ```Ruby
    class RestaurantsController < ApplicationController
   
      def show
        render json: @restaurant, include: 'dishes'
      end
   
    end
    ```
    
    ```Ruby
    class DishesController < ApplicationController
 
      def index
        @dishes = Dish.all
    
        render json: @dishes, include: 'restaurant'
      end
   
    end
    ```
    
    [<img src="/public/img/16.png" alt="Updated controllers code" height=150 width=100 />](/public/img/16.png)
    
    And I see updated info in JSON
    
    [<img src="/public/img/17.png" alt="Updated JSON" height=150 width=100 />](/public/img/17.png)


3. Setting up ActiveAdmin

    First of all I need to add required gems to Gemfile
    
    ```Ruby
    gem 'inherited_resources', github: 'activeadmin/inherited_resources'
    gem 'activeadmin', '~> 1.0.0.pre4'
    gem 'ransack',    github: 'activerecord-hackery/ransack'
    gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
    gem 'formtastic', github: 'justinfrench/formtastic'
    gem 'draper',     github: 'audionerd/draper', branch: 'rails5', ref: 'e816e0e587'
    gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
    
    gem 'jquery-ui-rails', '~> 5.0.4'
    ```
    
    And install them
    
    ```Bash
    bundle install
    ```
    
    After that we have to update `app/controllers/application_controller` from
    
    ```Ruby
    class ApplicationController < ActionController::API
    end
    ```
    
    to 
    
    ```Ruby
    class ApplicationController < ActionController::Base
    end
    ```
    
    And `config/application.rb`
    
    ```Ruby
    module NewApiApp
      class Application < Rails::Application
        # ...
        config.middleware.use ActionDispatch::Flash
        config.middleware.use Rack::MethodOverride
        config.middleware.use ActionDispatch::Cookies
      end
    end
    ```
    
    [<img src="/public/img/18.png" alt="ActiveAdmin configuration" height=150 width=100 />](/public/img/18.png)
    
    Now I will install ActiveAdmin. I won't be using any authentication, so I skip them.
    
    ```Bash
    rails g active_admin:install --skip-users
    rails db:migrate 
    ```
    
    When I visit `http://localhost:3080/admin` I see ActiveAdmin dashboard
    
    [<img src="/public/img/19.png" alt="ActiveAdmin dashboard" height=150 width=100 />](/public/img/19.png)
    

4. Creating and configuring ActiveAdmin resources

    Now I have to generate ActiveAdmin resources:
    
    ```Bash
    rails g active_admin:resource Restaurant
    rails g active_admin:resource Dish
    ```
    
    It will add sections to create, list, update and delete dishes, but default views and forms don't satisfy my needs, 
    so I will update them.
    
    First of all I will update `app/admin/restaurant.rb`, so it shows restaurant dishes count on index page and dishes 
    list on show page. And also I tell ActiveAdmin, which parameters can be changed:
    
    ```Ruby
    ActiveAdmin.register Restaurant do
      index do
        column :title
        column :description
        column :dishes_count do |product|
          product.dishes.count
        end
        actions
      end
    
      show do |restaurant|
    
        attributes_table do
          row :title
          row :description
        end
    
        panel 'Dishes' do
          table_for restaurant.dishes do |t|
            t.column :title
            t.column :dish_type
            t.column :ingredients
            t.column :description
            t.column :price
          end
        end
      end
    
      permit_params :title, :description
    end
    ```
    
    After that, I will update dish edit form so I can choose dish type from list. To do that, I have to create form partial
    at `app/views/admin/dishes/_form.html.erb`:
    
    ```ERB
    <%= semantic_form_for [:admin, @dish], builder: Formtastic::FormBuilder do |f| %>
        <%= f.semantic_errors %>
        <%= f.inputs do %>
            <%= f.input :restaurant_id, as: :select, collection: Hash[Restaurant.all.collect{|r| [r.title, r.id]}], include_blank: false  %>
            <%= f.input :title %>
            <%= f.input :dish_type, as: :select, collection: Dish.dish_types.keys, include_blank: false %>
            <%= f.input :description %>
            <%= f.input :ingredients %>
            <%= f.input :price %>
        <% end %>
        <%= f.actions %>
    <% end %>
    ```
    
    And render it from `app/admin/dish.rb`:
    
    ```Ruby
    ActiveAdmin.register Dish do
      form partial: 'form'
    
      permit_params :restaurant_id, :title, :dish_type, :description, :ingredients, :price
    end
    ```
    
    Now I can create, read, update and destroy restaurants and dishes from application backend. 
    
    [<img src="/public/img/20.png" alt="ActiveAdmin resources config" height=150 width=100 />](/public/img/20.png)
    [<img src="/public/img/21.png" alt="Form partial" height=150 width=100 />](/public/img/21.png)
    [<img src="/public/img/22.png" alt="New items" height=150 width=100 />](/public/img/22.png)
 
 
## Conclusions 

ActiveAdmin can be used if you need to implement backend for your database. It is flexible, customizable and can be easily 
integrated.

## Alternatives
[Rails Admin](https://github.com/sferik/rails_admin)
[Typus](https://github.com/typus/typus)
[Active Scaffold](https://github.com/activescaffold/active_scaffold)
 
