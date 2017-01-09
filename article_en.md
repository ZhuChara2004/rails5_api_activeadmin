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
    

## Models
This application will be used as a service for ordering food from local restaurants. So we need to have a few database models:
 - Dish (title, type, components, description, price)
 - Restaurant (title, description)
 
 
1. Scaffolding restaurant model
    ```
    
    ```
