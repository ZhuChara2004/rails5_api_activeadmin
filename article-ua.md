# Використання ActiveAdmin в якості бекенду додатків, написаних на Rails 5

## Підготовка

Я буду використовувати:
- Ruby 2.4.0
- Rails 5 з включеним ключем API
- SQLite
- ActiveAdmin


Підготовка додатку:

1. Створення каталогу для додатку:
    ```Bash
    mkdir rails5_api_activeadmin 
    cd rails5_api_activeadmin
    ```

    [<img src="/public/img/1.png" alt="Creating folder" height=150 width=100 />](/public/img/1.png)

2. Створення гемсету і встановлення гему rails
    ```Bash
    rvm use 2.4.0@rails5_api_activeadmin --ruby-version --create
    gem install rails
    ```
    
    [<img src="/public/img/2.png" alt="Gemset created" height=150 width=100 />](/public/img/2.png)
    
3. Ініціалізація репозиторію і генерація нового додатку Rails
    ```Bash
    git init 
    rails new . --api
    ```
    
    [<img src="/public/img/3.png" alt="Git and Rails" height=150 width=100 />](/public/img/3.png)
    
4. Встановлення Rails

    [<img src="/public/img/4.png" alt="Rails installed" height=150 width=100 />](/public/img/4.png)
    
5. Додавання файлів IDE до .gitignore базовий соміт

    [<img src="/public/img/5.png" alt="Gitignore" height=150 width=100 />](/public/img/5.png)
    [<img src="/public/img/6.png" alt="Initial commit" height=150 width=100 />](/public/img/6.png)
    
6. Запуск серверу з метою перевірки роботи додатку (я запускаю на порту 3080, але порт за замовчуванням - 3000)
    ```
    rails s -p 3080
    ```
    
    [<img src="/public/img/7.png" alt="Default rails root" height=150 width=100 />](/public/img/7.png)
    

## Database Models
Цей додаток буде використовуватись як сервіс замовлення їжі з місцевих ресторанів. Тому нам необхадно створити кілька 
моделей баз даних:
 - Dish (title, type, ingredients, description, price)
 - Restaurant (title, description)
 
 
1. Створення моделі ресторан

    Я буду використовувати вбудований в Rails генератор scaffold. Для цього, мені потрібно вказати поля, які я створюю для 
    моделі, а також їх тип. Тип за замовчуванням - string, тому його можна пропустити. Модель Dish належить моделі Restaurant,
    а Restaurant може мати багато страв. Крім того, я буду викорістовувати enumerable для типу страви.
    
    ```
    rails g scaffold Restaurant title description
    rails g scaffold Dish title dish_type:integer ingredients description price:decimal restaurant:belongs_to
    ```
    
    [<img src="/public/img/8.png" alt="Models generated" height=150 width=100 />](/public/img/8.png)
    
    В даному випадку я ігнорую попередження (код рельсів не оновлений до змін в Ruby 2.4.0).
    
    Крім того, під час генерування моделі Dish я викорстаю вбудований в генератор спосіб вказання на те, що ця модель 
    належить моделі Restaurant
    
    [<img src="/public/img/9.png" alt="Generated models code" height=150 width=100 />](/public/img/9.png)
    
    Тепер я повинен вказати, що модель Restaurant може мати багато об'єктів моделі Dish, а також вказати типи страв.
    
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
    
    Enum автоматично згенерує методи для типів страви і ці методи будуть доспні в додатку. А сам тип буде збережений в 
    базі як integer, що починається з `0` де кожне наступне число відповідає типу страви. 
    Наприклад: `0 - european`, `1 - pan asian`, `2 - wok` і т.д.
    
2. Міграція бази, налаштування контролерів та створення тестових даних

    Тепер мені потрібно мігрувати базу і створити тестові дані
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
    
    Якщо я перейду за посиланням `http://localhost:3080/restaurants` або `http://localhost:3080/dishes`, я побачу дані,
    збережені у базі у форматі JSON
    
    [<img src="/public/img/14.png" alt="Restaurants" height=150 width=100 />](/public/img/14.png)
    [<img src="/public/img/15.png" alt="Dishes" height=150 width=100 />](/public/img/15.png)
    
    Але я хочу побачити всі страви, які є в ресторані на сторінці цього ресторану, а також назву ресторану на сторінці 
    страви, тому мені потрібно внести зміни у відповідні контролери
    
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
    
    І я можу побачити, цо інфорсмація в JSON оновилась
    
    [<img src="/public/img/17.png" alt="Updated JSON" height=150 width=100 />](/public/img/17.png)


3. Підключення ActiveAdmin

    Перш за все, меня потрібно додати необхідні геми в Gemfile
    
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
    
    І встановити їх
    
    ```Bash
    bundle install
    ```
    
    Після цього потрібно внести зміни в `app/controllers/application_controller` з
    
    ```Ruby
    class ApplicationController < ActionController::API
    end
    ```
    
    на 
    
    ```Ruby
    class ApplicationController < ActionController::Base
    end
    ```
    
    І додати зміни в `config/application.rb`
    
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
    
    Тепер я встановлю ActiveAdmin. Я не буду використовувати аутентифікацію, тому я її пропускаю.
    
    ```Bash
    rails g active_admin:install --skip-users
    rails db:migrate 
    ```
    
    Коли я заходжу на `http://localhost:3080/admin`, я можу побачити дашборд ActiveAdmin
    
    [<img src="/public/img/19.png" alt="ActiveAdmin dashboard" height=150 width=100 />](/public/img/19.png)
    

4. Створення і налаштування ресурсів ActiveAdmin

    Тепер мені потрібно згенерувати ресурси ActiveAdmin:
    
    ```Bash
    rails g active_admin:resource Restaurant
    rails g active_admin:resource Dish
    ```
    
    Це додасть розділи для створення, перегляду, оновлення і видалення страв і ресторанів, але мене не влаштовує результат,
    створений за замовчуванням, тому мені потрібно внести свої зміни.
    
    Перш за все, мені необхідно оновити `app/admin/restaurant.rb`, щоб я бачив кількість страв в ресторані у списку 
    ресторанів і список страв на сторінці ресторану. Крім того, я вказую, які поля можуть бути змінені.
    
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
    
    Після йього, я оновлю форму редагування страви, щоб я міг обирати тип страви і ресторан із випадаючого списку. Для
    йього? мені потрібно створити паршиал в `app/views/admin/dishes/_form.html.erb`:
    
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
    
    І відрендерити його в `app/admin/dish.rb`:
    
    ```Ruby
    ActiveAdmin.register Dish do
      form partial: 'form'
    
      permit_params :restaurant_id, :title, :dish_type, :description, :ingredients, :price
    end
    ```
    
    Тепер я можу створювати, читати, редагувати і видаляти ресторани і страви за допомогою бекенду.
    
    [<img src="/public/img/20.png" alt="ActiveAdmin resources config" height=150 width=100 />](/public/img/20.png)
    [<img src="/public/img/21.png" alt="Form partial" height=150 width=100 />](/public/img/21.png)
    [<img src="/public/img/22.png" alt="New items" height=150 width=100 />](/public/img/22.png)
 
 
## Висновки 

ActiveAdmin можна використовувати, якщо необхідно реалізувати бекенд для БД. Він гнучкий, легко налаштовується і просто
інтегрується.

## Альтернативи
[Rails Admin](https://github.com/sferik/rails_admin)
[Typus](https://github.com/typus/typus)
[Active Scaffold](https://github.com/activescaffold/active_scaffold)
 
