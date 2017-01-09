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
 - Dish (title, type, components, description, price)
 - Restaurant (title, description)
 
 
1. Scaffolding restaurant model

    I will use built in Rails scaffold generator and define fields, that have to be created at a database, providing field type.
    The default type is string, so it can be skipped. The model Dish will belong to model Restaurant and Restaurant 
    can have many dishes. Also, I will use Enumerable on a dish type field.
    
    ```
    rails g scaffold Restaurant title description
    rails g scaffold Dish title type:integer components description price:decimal restaurant:belongs_to
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
    
    Enum will provide our application with automatically generated methods for dish type. And it will be saved in database
    as an integer starting with `0` where each next number will correspond to a dish type. 
    For example: `0 for european`, `1 for pan asian`, `2 for wok` etc.
    
