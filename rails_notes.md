#Rails Notes Sheet

```
Table of Contents
  Setup Ruby & Rails
  Routes
  Models & Migrations
  Views & Controllers
  Styling
    Asset Pipeline
  Deployment
```

#Unique Rails Methods
attr?             #return true or false for any attribute
nil.try(:method)  # converts Exceptions to nils
                  # can be interpreted as code smell, if you 
                  # use it when you don't know what you're doing.

#RVM              # controls which Ruby you use
>rvm install rubyversion                #install ruby
>rvm install 1.9.2                      #install ruby v1.9.2
>rvm install jruby                      #install jruby
>rvm list                               #list rvm rubys installed

## rvmrc                                #put this file in the app root
rvmrc> rvm 1.9.2@yourgemset                 #tell rvm to use ruby 1.9.2 with yourgemset
                                            #gemset is usually your the same as your app name
>rvm gemset create yourgemset               #create the gemset
                                            #ruby and gemset is now specifoc to the app


#Gotchas
Gotchas - Updating files...
1) New Models    > reload!
  Gotcha! reload! in the console updates code, but note existing objects
2) New Gems      > bundle install
3) New Migration > rails db:migrate
4) New Routes    > rails routes

## Make a New Rails App
>rails new app_name     # Make a new rails app.
>rails _4.2.1_ new name # Use a specific version of rails.
>cd app_name            # go to your rails apps root
>rails s                # start the server & open "localhost3000:" in a browser

## Gems
Gems are downloadable ruby programs. They're declared in /app_name/Gemfile
If the gems ever change, run the command below.
>bundle install         #Download any missing gems.
>bundle check           #Check for any missing gems.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Routing
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

??? Where in the guides or API can I learn about the *_path *_url methods?

Basic Routes
There are 4 types of routes in Rails:
routes.db>
  Simple route
    match 'user/index', :to => 'user#index', :via => 'get'  # long form
    get 'user/show'                                         # short form

  Root route 
    match '/', :to => 'welcome/index', :via => 'get'        # long form
    root 'welcome/index'                                    # short form

  Default route
    match ':controller(/:action(/:id)), :to => 'controller#action#id', :via => 'get'
    eg) http://localhost:3000/users/edit/1   # goes to the user controller, 
                                               edit action
                                               & user object with user_id of 1
  
  Resourceful routes
    resources :students  # generates the following

       students GET    /students(.:format)             students#index
                POST   /students(.:format)             students#create
    new_student GET    /students/new(.:format)         students#new
   edit_student GET    /students/:id/edit(.:format)    students#edit
        student GET    /students/:id(.:format)         students#show
                PATCH  /students/:id(.:format)         students#update
                PUT    /students/:id(.:format)         students#update
                DELETE /students/:id(.:format)         students#destroy

    Use (.:format) to direct to specific file formats.
    More information is available at the following. (Documentation is sparse on this!)
      http://doc.bccnsoft.com/docs/rails-guides-3.2-en/routing.html
      http://stackoverflow.com/questions/20320263/what-does-format-mean-in-rake-routes


!Gotchas
  Run rails routes after you update your routes.
  The order of the routes is important!
    Have your explicit routes run before your variable routes,
    otherwise your path may get gobbled up by a variable path
    so do root, new, edit, show (var), put (var), patch (var), delete (var)

!Debug
My failure for deleting, kept routing to movies/:id/edit

_path vs _url: 
  use path for views and url for controllers (simplified)
  Both will work, path takes up less space, 
  but for redirects, standards dictate using the complete url.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Custom Routes / Routing Strategies
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  High Level Concept
    Change your routes file to take a scope right after the existing path
      or with a new name space.
    Change your controller (probably index) to setup the correct scope.
  1a) Code each route by hand
     #for just a handful of routes
     routes.rb> get "events/past" => "events#index", scope: "past"
      #note 'scope' here is a params hash variable it does not refer to 
      to the actual scope method. 
     controller.rb> case scope
                    when "past"
                      @objects = Model.past
  1b) Use a ruby block
      #for more routes use a ruby block
      %w( ... ).each do |scope|
     get "events/#{scope}" => "events#index", scope: scope
      end
  1c) Use a constrained regex
      get "events/:scope" => "events#index", constraints:
        { scope /past|free/}  #regex at the end
      controller> #use case from strategy #1 above
  2)  Make a new namespace
      #for a large number use a name space
      #Also avoids namespace collisions
     routes>get "events/filter/:scope" => "events#index", 
              :as => :filtered_events
     view>link_to "#", filtered_events_path(:past)

#FRIENDLY URLS (SLUG METHOD)
Set Up The Model
  >rails g migration addSlugToModels slug  #add a slug column
  >rails db:migrate     #you gotta do that
  model> def generate_slug   #make a method to make slugs
            self.slug ||= name.parameterize
          end
    # self is so you don't make a local variable
    # ||= or equals is so the name doesn't, 
    #    that messes up links and search engines
  model>before_validation :generate_slug #a callback hooks into events
    #make sure to pass in the whole model object
    #to_param is called to convert object to link parameters
    #you'll have to check all your views and controllers, see below
  model>def to_param
          slug
        end
  console> Model.all.each { |m| m.save } #run the slugs
          #generate_slug is run because of the before_validation call
  console>Model.pluck(:slug)  #check to make sure you're slugs are there
Set up controllers and views
  controller> change find(#) to find_by(:slug => params[:id])
  controller> change nested models to find_by(:slug => params[:model_id])??
  views> make sure link_to's pass objects, not id's
    eg) @model, not model_path(model.id)  #that's specific number

Namespaces
routes.db>
  namespace :admin do
    root "..."          # root applies to namespace only
    resources :users    # users routes appear under admin now,
  end

# Research, view templates get inheritance... Rails4InAction (page 201)

# Custom Routes
  Outside of restful routing two common terms come up
  Member Routes - performed on a single object projects/1/archive
    restful routes under this category are show/edit/update/destroy
  Collection Routes - performed on group: projects/search || autocomplete || export
    a RESTful route under this category are index 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Resources
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rails g scaffold
  # To turn off all the jbuilder noise
      config.generators.jbuilder = false
  - create a migration, model, resource, controller, views, tests, 
      jbuilder, and scaffold.scss
    rails g scaffold MyModel --no-stylesheets  # turn off scss (tiny fonts!)
rails g resource
  - create a migration, model, resource, and blank controller
rails g scaffold_controller
  # short cut for controller and views


Concept
  To satisfy DRY, all routes should be identified by link_to(path_names) and not hard coded.
  The only hard coding of links should be in routes.rb
Go to a directory where you expect some action
Eg) localhost:3000/model
Rails is looking in config/routes.rb for a route to a controller and action
In routes.rb add
>routing_verb "url" => "controller_name#action_name"
eg
>get "movies" => "movies#index"

###Resource
  Concept: a bundle of predefined routes which do the following
  * list entities
  * show one entity
  * edit one entity
  * create a new entity
  * delete an entity

routes.db> resources :models

###params[]
*ANY URL PARAMATERS ARE AUTOMATICALLY CAPTURED IN A HASH CALLED PARAMS*
put 'fail' in your controller method and play with the url to see how params hash works
look at below to see how the params hash works
http://website/action/1
http://website/action/params[:id => 1]
Notes the it's params[:id], not params() b/c it's hash, not a method

from stackoverflow:

  http://www.example.com/?vote[item_id]=1&vote[user_id]=2
  params[:vote][:item_id] would be "1" and params[:vote][:user_id] would be "2".
  http://example.com?movie_id=1&stars=3&price=100  #See below
                                                   #The & and = are delimiters
      params = {:movie_id => 1, :stars => 3, :price => 100}

>http://localhost:3000/rails/info/routes        #show routes and paths useful for link_to helpers
* models_controller has a matching models_path for the url
* >rake routes                  #same as below - the goto command for routes
* >rails routes                 #shows routes, add _ + path for the helper, see below
* console>app_model_path        #will evaluate the path 'app' is the convention for console routing

###_path, _url
>rails routes                   #
Sample routes report
  route_name      HTTP_verb       pattern         controller#action
  -----------------------------------------------------------------
  movies          GET             /movies         movies#index

model_path                      #resolves to app_root/model_path      use for views 
model_url                       #resolves to http://app_root/model_path  use for controllers
Above both work but by convention it's so.
Video example
  routes.db> get 'movies/:id' => 'movies#show', as: 'monkey'
  rails c>   app.monkey_path(1)   #returns /movies/1
  view file> link_to(name, model_path(#))        #same command as below
  view file> link_to(name, model)                #b/c of the routes.db as: command,
                                                    rails resolved model to the above command
  ! Gotcha: don't forget to keep track of whether its a local or instance variable.
     link_to('name', @model) || link_to('name', model)
  ! Gotcha: nested paths need *two* variables, especially for delete

    link_to 'Edit', [:edit, @owner, @pet]               # Shorthand for below
    link_to 'Edit', edit_owner_pet_path([@owner, @pet]) # Same as above.


    link_to delete_path(@parent, @child)  # Got that?
    If you only provide one, it will repeat that one twice (a nasty bug to track down)

###Nested resources
    routes.db> resources :a do
                resources :b
               end
    #creates /a/1/b  routes 
    http://example.com/rails/info/routes      #look at all created paths
    Note that nesting changes the route id's
    Example)
      resources :parent do
        resources :child
      end
    parents/parent_id/children/id
    So params now holds a params[:parent_id] and a params[:id]
  
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Controllers
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
The full name should be *View* Controller.
Work Hand In hand with view templates.
Examples
0) 'layout false' will turnoff off the layout/application.html.erb template.
1) Set Up Variables
2) render 'controller/action' #current controller is default
2) render 'action'
2) render :action             # all the same
2) redirect_to root_url
2) redirect_to 'http://kevinjacksonart.com' #perfectly valid

#Basic CRUD Controller Page
  Tip:
    By Convention, controllers are usually defined in this order:
      index, show, new, create, edit, update, destroy

  before_action :set_model, :only => [:show, :edit, :update, :destroy]

  def index
    @models = Model.all               #or custom query
  end
  def show
  end
  def new
    @model = Model.new
  end
  def create
    @model = Model.new(model_params)
    if @model.save
      redirect_to @model, notice: "Model succesfully created!"
    else
      render :new
  end
  def edit
  end
  def update
    @model = Model.find(params[:id])
    if @model.update(model_params)
      redirect_to @model, notice: "Model successfully updated!"
    else
      render :edit
  end
  def destroy
    @model.destroy
    redirect_to model_url, alert: "Model successfully deleted!"
  end
private
  def set_model
    @model = Model.find(params[:id])
  end
  def model_params
    params.require(:model).permit(:attr1, :attr2, :attr3)
  end

#1:M Version
  Replace set_model, with set_parent
  and use before_action()
  controller>class ChildrenController < ApplicationController
                before_action :set parent


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
Flash Hash
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  

  Concept flash[:notice] or flash[:key] can be passed with redirects.

  Basic Concept
  1) controller> redirect_to link, notice: "Success message!"
      # flash = {:notice => "Success message!"}
  2) application_layout.erb>        <%= flash[:notice] %>  
  
  layouts/_flashes.html.erb>
    <% flash.each do |key, value| %>
    <%= content_tag(:p, value, :class => "flash #{key}") %>
    <% end %>
  layouts/application.html.erb>
    <%= render 'layouts/flashes' %> # insert above yield

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
Views
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  

Concept
  Generates HTML.
  What to do here:
    Use the data from the controller.
  Basic syntax *.html.erb>
    <%= ruby code to be printed %>
    <% ruby code to not be printed %>
    <%# comment only %>



###Helpers / (View) Helpers
Concept
  *View* helpers keep your erb file nice and clean.
  Gotcha!
    Look on api.rubyonrails.org first to not duplicate work.
Common Helpers
    # HTML
        content_tag(name, content, options = {})
        content_tag :h1, "My Header"   #why does a tag become a symbol !!!???
        text.html_safe                 #make tags in erb processable html; cleaner to use above
        link_to '&spades;'              # => '&spades;' (not desired)
        link_to '&spades;'.html_safe    # => a picture of spades (good!)
    # TEXT
        pluralize(count, singular, plural = nil)
        truncate(text, options = {})
    # NUMBERS
        number_to_currency(number, options = {})           
        number_to_percentage(number, options = {})           
        number_with_precision(number, precision: n)
        number_with_precision(1, precision: 2)       #->1.00
    # TIME
        See full section on time below.
    # LOGIC
        if objects.any?   #conditional display
          ...
        end
    # ARRAYS
        collection(method, collection, value_method, text_method)
        collection(:genre_ids, Genre.all, :id, :name)  #example
    # ACTION-SPECIFIC LAYOUT CONTENT
      How it works.
        templates (show.html.erb) are rendered before the layout (application.html.erb)
      So define :title in a template, and application can use it if defined. 
        You can check if it's defined by using content_for?

        content_for(name, content=nil, option={}, &block)
        content_for(:sidebar) do &block end #
        content_for(:title, @movie.title)
        content_for?
          # Example
      show.html.erb> <% content_for :title, "Projects" %>
      application.html.erb 
        <% if content_for? :title %>
          Ticketee - #{:title}
        <% else %>
          Ticketee
        <% end %>
                          
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Dates & Times
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Ruby and Rails Date & Time Basics
  Epoch / Unix / POSIX time is a modern scientific standard which counts 
    seconds from Thursday, Jan 1st, 1970, the current iteration of UTC time.
  UTC, is a modern iteration of GMT, which accounts for leap seconds.
  Time uses modern Epoch time to track time.
  Date uses the earlier Julian calendar which doesn't account for leap years.
  Datetime is a subclass of Date which addes time data to the date class.
  Datatime back applies the Gregorian calendar to pre-Gregorian dates.
  Popular databases use Datetimes, always recorded in UTC.
  See http://blackbytes.info/2015/12/ruby-time for Ruby time basics.
  See http://danilenko.org/2012/7/6/rails_timezones/ for Rails time basics.
  
  Strategy: get all times to one time zone, so there's no discrepancies, 
    between server time, local time, app time, and database time. 
    1) Configure your app to a specific time zone.
    2) Use rails specific methods which translate the time.
      GENERALLY USE: Time.zone or Time.timemethod.in_time_zone
      Time.zone.now, Time.now.in_time_zone
      Date.current
      Time.zone.at(timestamp)
      date.beginning_of_day/end_of_day
    !!! Do *not* use:
      Time.now, DateTime.now
      Date.today
      Time.at(timestamp)
      date.to_time
      
Formatting Time
  Run rake time:zones:all to see a list of time zones.
  In application.rb, set the application time zone.
    config.time_zone = 'Pacific Time (US & Canada)'
  Similar to rubular.com for testing regex,
  http://strftime.net is a handy tool for playing with strftime() formats.

    t.strftime("%Z") # these two are equivalent
    t.zone

  Dates  live in the config/initializers dir
  Create a config/initializers/date_time_formats.rb
  date_time_formats>Date::DATE_FORMATS[:default] = "%B %e, %Y"
  date_time_formats>Date::DATE_FORMATS[:custom] = "%B %e, %Y"
                                                  "%h %d, %Y" => Sep 16, 2016  => 3:11 pm
                                                    "%l:%M %P"  => 3:11 pm
  Call with <%= %>
  Gotcha! > Reboot the server for your format to take effect.

rails c>ri Date.strftime research formats
! To Do : Figure out if there's a matching FORMAT for Time.
> "2016-01-01".to_date.beginning_of_day
 => Fri, 01 Jan 2016 00:00:00 PST -08:00 
> "2016-01-01".to_datetime.beginning_of_day
 => Fri, 01 Jan 2016 00:00:00 +0000                   !!! No Time Zone
> "2016-01-01".to_date.in_time_zone.beginning_of_day
 => Fri, 01 Jan 2016 00:00:00 PST -08:00 
> "2016-01-01".to_datetime.in_time_zone.beginning_of_day
 => Thu, 31 Dec 2015 00:00:00 PST -08:00 
Best resource
  https://www.youtube.com/watch?v=X-1ISHNEB9U # Railscasts on Time Zones
  Perfect for setting up users with config options.

  time_ago_in_words(from_time)
  * >ri Date.strftime          #info to format your dates
  * !!! Go back to Helpers, Exercise 7 Minute 16 to learn about dates and do the bonus round.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####Custom Helpers
+ Go in app/helpers/models_helpers.rb
+ Put business logic into methods in model.rb
  * Eg) 
  * Step 1: Have the view call method like 'format_data(model)', 
      which doesn't exist yet.  
  * Step 2: In the app/model_helper.rb file write the method which 
      calls 'is_my_condition?' method.
  * Step 3: In the model.rb, write the method 'is_my_condition?' 
      * Note: by convention methods with a question mark return true or false.
    * Also self.is_my_condition is not necessary - 
      it's assumed to be the model.
    * Note - nils can throw exceptions. Rails provides a blank? 
      method will returns true for nils.

###More Helpers
    button_to       # buttons default to the http post method
    link_to         # *may* be set to the http delete method 
                      & style as a button

##Models
Concept
  + Access the database table
  + Maps rows to objects
  + Aply business logic (to models): methods & validation

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Validations                                 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    * Concept: Prevent bad data from entering the database.  
        Bad data causes nasty bugs which break your whole app.
    * When you use a validation method, like validates, rails creates a 
      model.errors hash.  
    * Rails generates default error messages, which can customized
      with the :message attribute.
    * Rails also uses type casting !!!  *Before validation* rails will
      _change_ your attribute based on it's sql type. For example
      an invalid date, will be converted to nil _before_ your validation
      runs.  *** Need to research this more. ***

    #validate_attribute vs validates  :attr     Below are all the same command
    model> validates_presence_of :attr
    model> validates :attr, :presence => true 
    model> validates :attr, presence: true    # most common syntax.
    model> validates list of attributes, list of hashes     
                                              #this is not in the docs
    model> validates :attr1, attr2, attr3, presence: true   #list of attr
    model> validates :attr, length: {minimum: 25}            #set length
    model> validates :attr numericality: {only_integer: true} #set number only
    model> validates :attr, allow_blank: true,  
    model> validates :title, presence: { message: "custom message" } #see rails guides for more info

    validates :attr,  :presence => boolean,
                      :numericality => boolean,
                      :length => options_hash,
                      :format => {:with => regex},
                      :inclusion => {:in => array_or_range}
                      :exclusion => {:in => array_or_range}
                      :acceptance => boolean
                      :uniqueness => boolean
                      :confirmation => boolean
                      :validation method => {:requirement => value
                                             :option => option_value}
                      :length => {:minimum => 4, :message => "too short"}
                      
    (Console) Model Validation Methods
    >model.valid?                             # !This runs validates
    >model.errors                             # produce a non-friendly list of errors
    >model.errors.full_messages               # produce a friendlier list of errors
                                              # use below to be styled!
    >model.errors.full_messages.to_sentence   # array of error messages
    >model.errors[:attribute]
    >model.errors.any?                        # check for >= 1 errors
    >model.errors.many?                       # check for >1 errors

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Handling Errors in the View
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
In your any _form file right after <%= form %>
  <%= render 'shared/errors', :object => @model %>

make app/views/shared/_errors.html.erb file
  <% if object.errors.any? %>
  <section id="errors">
    <p>Ooops!</p>
    <ul>
      <%  object.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  </section>
  <% end %>

Styling Error Messages
  *Rails wraps any form errors in an HTML div with class set 
    to "field_with_errors"
  View source to check out.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ###ActiveRecord::Calculations
      Rail methods for columns of a database
        count (like length / size)
        maximum, minumum
        average
        sum
        calculate #long form of the above commands
        ids       #return an array of column id's
        pluck     #return an array of column values

>class Model < ActiveRecord::Base       #Model inherits form ActiveRecord
>rails g model mymodel name:string price:decimal #make mymodel and create database schema
DATABASE TYPES: 
  .string | text                          #string :limit = 255
  .integer | decimal | float              #use decimal for up 38 digits
  .boolean | binary
  .date | time | datetime
  .primary_key
  .timestamp
>rake db:migrate                        #Rails 4, 
>rails db:migrate                       #Advance database 
>rails db:migrate:status                #Check on database status
>rails db:rollback                      #Revert database 1 step
>cat db/schema.rb                       #look at the current schema

#Database
  ##Seeding
  Concept put in default data into your database
    app/db/seeds.rb>  put in create date in a hash
  >rails db:reset       #clear database *and* run db:seed the database
  >rails db:seed        #seed data (it's additive), run twice and you'll have double data
                        #note db:reset runs this for you.
  >rake db:drop db:create db:migrate  
                        #purge your database and return to current schema
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Migrations
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Naming convention: use yourMigrationChangesToTablename /
your_migrations_changes_to_tablename Rails will select the tablename in the
suffix. If you don't name it that, you can select the table yourself in the
migration file.

Question: 
  When do you use a >rails g migration|model|resource|scaffold ?
Answer:
  You need to think ahead for what you need.
    A migration updates your database tables.
    A model     updates your database tables, and makes a model (for defining relationships).
    A resource  does the first two, and makes a controller.
    A scaffold  does the first two, makes a controller and 7 views.

Setup
>rails g migration model name:string color:string

Changes
>rails g migration addAdminColumnToModel 

Search for migration at http://api.rubyonrails.org/
  for clear instructions on changing your schema.

####Defaults
>rails g migration setDefaultsToModel
Methods
  change_table :models do |t|
    t.change_default(:column, :from => nil, :to => "...")
  # use :from, :to with the change method to enable rollbacks!!!

####Ripple Effects Checklist
    * generate and apply the migration
    * add values for the new fields, if necessary
    * update all the affected templates


##Rails Console
>reload!                                #run this to refresh the console

##CRUD 
  Concept: Create, Read, Update, Destroy for Web Objects

###Create
Model.create, Model.find(#) |  Model.find_by(attr: "string"), Model.update(), Model.destroy
Create objects and assign attributes individually
>e = Model.new          #instantiate
>e.name = "Name"        #assign attribute
>e.save                 #save to database

Create objects and assign with hash
>e = Model.new(name: "Name", price: 15.00)
>e = Model.new(:name => "Name", :price => 15.00)  #same as above, alternate hash syntax
>e.save

Create and save in one step with a hash
>e = Model.create(name: "Name", price: 15.00)
>Model.create(name: "Name", price: 15.00) #Same as above, with a variable assignment

###Read
>count = Movie.count                    #return how many Movies there are.
>e = Movie.find(3)
>e = Movie.find_by(price: 15.00)
>e = Movie.all                          #returns an array of all table Models

###Update
>e.Event.find_by(price: 15.00)
>Model.destroy(3)           #destroy by primary key using the Class method
>e.update(name:"Kata Kamp", price: 30.00) #writes the database

###Destroy
>e = Event.find(3)
>e.destroy

##Rails Database Console
>rails dbconsole
sqlite> .schema                 #output all schemas
sqlite> .schema models          #output schema for models table

#Database 
##Queries
??? If I make parent.children query I get back an 
  ActiveRecord::Associations::CollectionProxy, not an array!
  what's going on here?
  ActiveRecord refers to the database code library

!!! model.select is database expensive!!! creating a db hit for every record.

 !!! Do not put queries in the controller

   Make a method in the model
   model>def self.myquerymethod
   model>    where('attr > 1000').order('attr asc')
   model>end
   controller>@Models = model.myquerymethod

  Play with in rails console
  Methods: (Model.method)
    * count(), 
    * all, 
    * order(:first_name => :asc) # defaults to alphabetical / asc / ascending
    * order(:first_name)         # same as above, asc is default
    * order(:week, :day => :desc) # sort first by week, & nested reverse days 
    * first 
    * last
    * find(id)
    * find_by(attr)
    * find_by(attr1, attr2)
    * where(key: "value")               #where, means conditionals in database-speak
    * where.not(key: "value")
    * where('price <= 10.00')
    * where('price <= ?', max_price)    #substitute variable into ?
    * where("starts_at >= ?", Time.now) #return upcoming event
    * to_sql                            #return the sql
    finished examples
      >Movie.where("released_on <= ?", Time.now).order("released_on desc")

  Article: 
  http://guides.rubyonrails.org/active_record_querying.html

    find
    create_with
    distinct
    eager_load
    extending
    from
    group
    having
    includes
    joins
    left_outer_joins
    limit
    lock
    none
    offset
    order
    preload
    readonly
    references
    reorder
    reverse_order
    select
    distinct
    where
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Scope
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Basic concept             # A way to name a custom query
  Why not a method?         # Expressive, Syntactic Sugar     
  Like a method,but         # enforces correct # of arguments, and
                            # supports defaults
  scope :name, lambda{sql}  # Two parameter method 
  scope :name, ->{sql}
  scope :name, -> {}
  scope :name, -> (name=default){name} # Pass in argument(s)
  scope :past, -> { where('starts_at <?', Time.now).order(:starts_at)}
  scope :recent, -> (max=3) { past.limit(max) }
  console> Model.scopename
  console> Model.recent(3)
  console> Model.hits.where("total_gross > 4000000")   #chain sql 
  console> Model.hits.recent                           #chain scopes
  console> user.favorite_movies.hits            #chain on through associations
  # Adding an attribute column
  # Class Method
  total = Model.scoped.pluck(:id).sum  #not tested ~~~something like this
  # Collection Method
  total = @items.map(&:id)

##Advanced
  #Use a lambda in the model declaration to adjust how a model is ordered
  model.rb> has_many :reviews, :dependent => :destroy
  model.rb> has_many :reviews, -> { order(created_at: :desc) }, 
                     :dependent => :destroy

##Gotcha
    scope :name, lambda sql   #gotcha! you need a block {}

##Database Question
    When I delete a row, the deleted number stays taken.
    How do I reset the database to reuse those numbers?
    Is that something I want to do?

    When I set up :dependent => :destroy on a through model
      is the opposing model destroyed, or only the join model?

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
RELATIONSHIPS
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Foreign Keys
    Child objects always get the foreign key
    Names are always singular, eg) foo_id, parent_id
    Non-conventional foreign keys can be set with { :foreign_key => foo_id }
      in the model file.
    Foreign keys can reference different columns, eg
      author_id can contain #{user.id} Rails4InAction, pg 164

console> delete versus destroy
    delete will set the foreign key to nil
      eg) parent.child.delete (leaves an orphanted child object)
    destroy will set the foreign key to nil and destroy the child object
      eg) parent.child.destroy (deletes the child objects
    Rails 5 does not allow the creation of orphaned child objects
    Rails 5 also runs a *save* on new child objects if you set a foreign key

##One-to-many | 1:M
    >rails g resource child attr:string parent:references
        (migration> t.references :parent, foreign_key:true)
                                  #'t.references :parent' addes the parent_id
                                  #'foreign_key: true' requires a valid parent_id 
    childmodel> class Child <ActiveRecord::Base
                  belongs_to :parent
                end
    parentmodel> has_many :registrations, dependent: :destroy  #notice the colon in :destroy
          #dependent: :destroy is necessary or there will be orphaned children

    # has_many creates the child methods, as well as the build method

###New Methods
    >parent.children   #lists children objects
    >child.parent      #lists parent object
    >child.parent_id = index_number     #two ways to set
    >child.parent = parent_instance     #convenience method, same as above

###Gotcha!
    Work in your console to make sure everything is working before you switch to UI setup.
    controller> @child = Child.new #don't do this, reference the use the parent relationship
    controller> @child = parent.children.new    #This sets the foreign key for you!

##Forms
  4 Levels of Forms
    1) Straight HTML - rails will save typing and apply security 
    2a) form|label|text_field _tag - good for model-less objects, such as searches
      Best for MAKING NEW ELEMENTS, UNASSOCIATED WITH MODELS

      Basic Hash
        text_field_tag 'name[first]' 
        text_field_tag 'name[last]'  => "name"=>{"first"=>"a", "last"=>"b"}
        # Infinite hash nesting is allowed
      Arrays
        3.times { number_field_tag :numbers[] } => numbers => [1,2,3] # arrays
          # Repeated names will become an array
          # Arrays are only allowed at one level
      An array of hashes
        <%= text_field_tag 'addresses[][line1]' %>
        <%= text_field_tag 'addresses[][line2]' %>
        <%= text_field_tag 'addresses[][city]' %>
          => "addresses"=>[{"line1"=>"123 main st", "line2"=>"apt 5", "city"=>"boise"}]


    2b)
        text_field(!!!object, method)
        eg)  text_field :person, :name
        access in params[:object][:name]
    3b) form_for
          saves typing buy binding an object to a form
          access in params[:object]

    Review of Helpers
    # input a key with no associated model, return a key:value hash
        text_field_tag(:key)          
        text_field_tag(:search)       
                      => <input id="search" name="search" type="text">
    # input a object and method, return an object and name:value hash
    # note you don't need an attribute, a method will work
        text_field(:object, :method)    
        text_field(:person, :age)     => <input id="person_age" 
                                                name="person[age]" 
                                                value="#{@post.title}" />
    # input an attribute to a bound / form_for(@object)  model
        f.text_field(:age)                                                  

###Basic form_for()
  erb> <%= form_for @model do |f| %>
  erb> <%= form_for [@parent, @child] do |f| %>   #1:M version
  erb>  <%= f.label :attribute %>
  erb>  <%= f.text_field :attribute %>   #go ahead and iterate your attributes
        #Pick from an array defined in your model.
  erb>  <%= f.select :attr, MODEL::ARRAY, prompt: "Pick one" %>  
  erb>  <%= f.submit %>  #submit is awesome it's automatically setting up the right patch route!
  erb>  <%= f.submit 'Custom Text' %>  #submit is awesome it's automatically setting up the right patch route!
    ##With  b/c Create / Update both use _form, customize like this:
      <% if @model.new_record? %>
        <%= f.submit "Create Model" %>  
      <% else %>
        <%= f.submit "Update Model" %>  
      <% end %>
  Basic form_for methods:  
   label            # use with all to indicate your attribute
   check_box        # Choose a boolean.
   radio_button     # Choose from a list an array element.
   text_area        # Enter a longer string.
   text_field       # enter a string.
   select           # Choose from a drop down an array element.

Partials

render(view, locals, buffer=nil, &block)
  locals is a hash accessed by local_assigns

  Contrived Example
    render(:something, :pie => "apple")
    something.html.erb> <h1><%= :pie %></h1> # => <h1>Apple</h1>
  Useful Example
    render('shared/errors', :object = @user)
    :errors.html.erb> <% object.errors each do |error| %> ...

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Complex Forms, Nesting, & field_for
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class Person
  has_many :addresses, { :inverse_of => :person }
  accepts_nested_attributes_for :addresses
      # This adds an addresses_attributes= method to Person

class Address
  belongs_to :person, { :inverse_of => :addresses }
      # inverse_of or 'required: false' is necessary for rails 5

Template
  form_for :person do |f|
    ...
    fields_for :addresses |a| # Note that address is specified as *symbol*
                              # Need to practice raw html and form builders.
      a.text_field :street
    end
  end

Controller
  
  Basic Nested Controller Code
    before_action :set_owner # basic...
    def new
      @pet = @owner.pets.build
    end
    def create
      @pet = @owner.pets.build(pet_params)
      @pet.save ? redirect_to [@owner, @pet] : render "new" # abbreviated
    end
    def pet_params
      params.require(:pet).permit(:name)

  @person = Person.new
  2.times { @person.address.build }  # Make a couple of addresses for the view

  def person_params                  #  Whitelist addresses_attribute
    params.require(:person).permit(:name,  
      :addresses_attributes => [:street, :city, :state, :zip])
  end

Reference:
    http://guides.rubyonrails.org/form_helpers.html #complex forms
    # Missing information on inverse_of !!!

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
select_tag
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
The HTML is you are trying to generate is this:
  <select name="student_id" id="student_id">
    ...
    <option value="10">Darren</option>
    ...
  So you need to provide three objects: model_name, option_name, option_value
    options_for_select() is an array of arrays for your option_name and option_value
    select_tag() takes your model_name and options_for_select().
      select_tag(model_name, options_for_select(options_array)
    Production Example : assuming @unenrolled is an filled
        <% unenrolled_options = [] %> # move to the controller once it's working
        <% @unenrolled.each { |u| unenrolled_options << [u.first_name, u.id] } %>
        <%= select_tag(:student_id, options_for_select(unenrolled_options)) %>
    Basic Example
        <% planet_options = [["earth", 1], ["mars", 2], ["venus", 3]]
        <%= select_tag(:planets, options_for_select(planet_options))

    !!! Research - options for collections
    !!! Too much logic in view


  * Gotcha! Notice the first line starts <%= and last line starts <% end...
  route.db> PATCH '/model/:id' => 'model#update' #Wooppee! let's get this saved

  model_controller> def update
  * Debug         > fail               #now you can see what's in params[] in the browser 
  model_controller>     @model = Model.find(params[:id]
  * Gotcha! Below is insecure
    model_controller>@model.update(params[:model])  #this should work, but is insecure - Rails rejects it as a bad idea
  model_controller>     @model.update(secure_params)
  model_controller>private
                    def secure_params 
                      params.require(:model).permit(:attr, ...) 
                                                   (:attr => []) #for an array
                    end

### Child Helpers
      erb> <%= link_to "index",   parent_children_path(@parent)       %>
      erb> <%= link_to "new",     new_parent_child_path(@parent)      %>
      erb> <%= link_to "edit",    edit_parent_child_path(@parent)     %>
      erb> <%= link_to "show",    parent_child_path(@parent, @child)  %>
      erb> <%= link_to "show",    [@parent, @child]                   %>  # Shortcut method
      erb> <%= link_to "delete",  [@parent, @child].method: :delete   %>
####New Action
  Similar to above
  route.db> GET '/model/new' => 'model#new', as: new_model_path
  route.db> POST '/model' => 'model#create' #once you're done creating this gets called
                                            #resources puts this one line above, not sure why
  !!! Check to see if doing 
    @model = Model.new(model_params)  #pass in params right from from params hash
    @model.save
     ==
    Model.create(model_params) #pragmattics does it differently

####Destroy Action
    routes.rb> DELETE '/model/:id/' 'model#delete'   #no path necessary, because of the delete verb
    erb> <%= link_to 'Delete', model_path(@model), method: :delete %> #otherwise  will choose the GET method
    erb> <%= link_to 'Delete', model_path(@model), :method => :delete, 
                                                   :data {confirm: "Confirm delete?"} %> 
            #same as above with confirmation message

    ### Sample Delete Link 
      <%= link_to 'Delete Account', user_path(@user),                                                          
              :method => :delete, 
              :data => { confirm: "Are you sure?" }, %>

#Sample CRUD Controller
    class MoviesController < ApplicationController
      def index
          @movies = Movie.all
      end
      def show
        @movie = Movie.find(params[:id])
      end
      def new
        @movie = Movie.new 
      end
      def create
        @movie = Movie.new(movie_params)
        @movie.save
        redirect_to movies_path
      end
      def edit
          @movie = Movie.find(params[:id])
      end
      def update
          # fail  #use to debug params[]
        @movie = Movie.find(params[:id]) #first load the right movie
        @movie.update(movie_params)      #then overwrite with new params
        redirect_to @movie
      end
    end

    private
    def movie_params
        params.require(:movie).
          permit( :title, :description, :rating, :released_on, :total_gross
          )
        # params.require(:model).permit(:attribute)
    end

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Relationships #M:M Many to Many
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    ##Make a join model / join table
    Concept: It's very simple table with 3 columns to neatly
              describe a child with multiple parents.
              Consider school mith many classes and many students.
              An enrollment is the child of both,
              and a row in the enrollment table would reference 1 student and 1 class.
              Easy!

              Another way to think of it is that a M:M relationship
              is simply two 1:M relationships or this:  1:M:1.
      1) It's own id
      2) A parent's foreign key
      3) Another parent's foreign key

#command for a join table
      rails g migration CreateMediaJoinTable artists musics:uniq

#M:M Through association
    If the join table does not carry data, only a link, 
    use a through association. An example is a like button between
    a user and movie.
      Why?
        The join table (child table) requires a database query for every 
        access of the opposite parent table. A through association
        reduces the database query to 1.
    > rails g resource child parent1:references parent2:references
    routes.rb> next the child in desired parent
          #You'll need one of the parents in the params[]
    parent1.rb> has_many :children, :dependent => :destroy
                has_many :children, :dependent => :delete_all 
                  # faster if there are no callbacks, minimizes the sql
                has_many :parent2s, :through => :children

                #custom naming version below
                has_many :parent2s_custom_name, 
                         :through => :children, 
                         :source => :parent2 (singular)
    Repeat for parent2.rb
    Example:
      class.rb>   has_many :enrollments, :dependent => :destroy
                  has_many :students,    :through => :enrollments
      student.rb> has_many :enrollments, :dependent => :destroy
                  has_many :classes,     :through => :enrollments

    methods
        After instantiating parent1 and parent2

        # List
        console>  parent1.parent2s  #list
                  parent2.parent1s
                  parent1.parent2_ids    #return an array of ids
        example>a student.classes
                  class.students
                  john = Student.find_by(name: "John")
                  algebra = Class.find_by(name: "algebra")

        # Create 
            Preferred Way
                  parent1.parent2s.create!(parent2: parent2_instance_name)                
                    john.classes.create!(class: algebra)
                    algebra.students.create!(student: john)
                  parent1.parent2s << parent2_instance_name
                    john.classes << algebra
                    algebra.students << john
            Long Way
                  e = Enrollment.create!(student: john, class: algebra)

        Gotcha!
                  If you use the create! method use the parent 
                    and child names without the alternatives
                  if you use a :source, the shorthand (push) method
                    only works on the alternative name!
        example   user and movie are joined by favorites
                  movie.rb> has_many :fans,            
                              :through => :favorites, 
                              :source => user
                  user.rb>  has_many :favorite_movies, 
                              :through => :favorites, 
                              :source => movie
        console>  movie.favorites.create!(user: user)          # Good
                  movie.fans.create!(user: user)               # Bad

                  movie.fans << user                           # Good
                  movie.favorites << user                      # Bad

                  user.favorites.create(movie: movie)          # Good
                  user.favorites_movies.create!(movie: movie)  # Bad

                  user.favorite_movies << movie                # Good
                  user.favorites << movie                      # Bad

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Exceptions
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
In development mode all errors get a full stack trace because
  config/environments/development.rb has
    consider_all_requests_local = true # See Rails4InAction, pg. 99

To handle bad routing gracefully try this:

Controller>
  def set_model
    @model = Model.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The model you were looking for could not be found."
    redirect_to models_path
  end

Global Rescue Method: rescue_from
Upside: friendly message, doesn't look like a mistake
Downside: can making debugging more difficult!

application_controller.rb>
  rescue_from ErrorClass, :with => :method

  Eg)
      rescue_from Pundit::NotAuthorizedError, :with => :not_authorized 
     
      private 
       
      def not_authorized 
        redirect_to root_path, :alert => "You aren't allowed to do that." 
      end 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Deployment
  config/environments/
    * development
        * code reloading
        * verbose logging
        * caching disabled
        * exceptions
    * production
        * no code reloading
        * less verbose logging
        * caching enabled
        * friendly error pages
        * precompiled assets
    * test

  1) *Don't* change database.yaml file
  2) Gem file> 
      source 'https://rubygems.org' 
      ruby '2.3.0' #Specify exact version
  3) Put gem 'sqlite3' into group
    group :development, :test do
      gem 'sqlite3'
    end
    group :production do
      gem 'pg'
    end
  4) bundle install --without production #or pg / postgres will attempt on your machine and fail

## Initial Heroku Deployment
  concept
    git init/commit on your machine, then push onto heroku
  1) run all your tests
  2) git commit
  3) heroku login
  4) heroku create (if needed)
  5) git push heroku master
  6) heroku run rake db:migrate
  7) heroku open

## Folloup Heroku Deployment
  1) run tests
  2) git add -A; git commit -m "..."
  3) git push heroku master

## Heroku troubleshooting
  heroku logs
  heroku run console # your production console!

### Gotcha
  Precompiling assets failed on heroku push.
  Solution: 
    RAILS_ENV=production bundle exec rake assets:precompile
      showed I had an extra semicolon in my application.css file!

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Asset Pipeline
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  The 'Sprockets' gem manages the your css and javascript, which
    it calls the 'asset pipeline'
  asset pipeline = CSS + JS + csrf meta tags managed 
  CSRF metatags is basically an encryption service. Every page reload changes
    the csrf-token (passkey). 
    In development files are kept separate for debugging
    In production files are bundles and minified for speed
  Sprockets looks for /assets/application-[digest].css and will preprocess
    if there's any additional extensions on it such as .scss (multiple
    extensions work as well).
  Sprockets looks at the /assets/javascripts/application.js manifest 
    "//= *"
    and similarly manage js and coffee files. *"
  Great read about jquery-ujs (unobtrusive javascript)
  Unobtrusive javascript in short, writes event-handlers for you
    https://robots.thoughtbot.com/a-tour-of-rails-jquery-ujs
      links: <%= link_to ..., method: :delete %> 
          # writes data-method= for you
      form_for ..., data: { confirm: 'Are you sure' }
          # writes data-confirm for you
      form.submit ... data: { disable_with: '...' }
          # writes data-disable-with for you # prevents accidental double submission
      form_for ..., remote: true
        setus up AJAX for you.. # how?
      AJAX file uplods are possible...
      HTML Field Validation can be turned off
      Handles CSRF (see above)
      Exensibility
        $.rails namespace gives access to the jquery-ujs functions.

  Using javascript. 
    Turbolinks is a gem in rails which turns your linkts into javascript
      in order to speed up your site.  For server side websites, it works
      well, but for **sites that use javascript** it's trouble.  Disable
      by the following:
        1. Delete from your gemfile, and run 'bundle'.
        2. Delete '//= require turbolinks' from  from app/assets/javascripts/application.js
        3. Remove the turbolinks calls from application.html.erb so it looks like this.
          <%= stylesheet_link_tag    'application', media: 'all' %>
          <%= javascript_include_tag 'application' %>    
  Coffeescript:
    The 'coffee-rails' gem will make an assets/javascripts/[controller_name].coffee
      file everytime you make a new controller.


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Styling
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

application_layout> 
  * stylesheet_link_tag : css helper
  * csrf_meta_tags : security

Where rails looks for CSS
  * app/assets            #app specific
  * lib/assets            #your shared libraries among different apps
  * vendor/assets         #3rd party css

## Sass - a programming language for CSS built by Rubyists.
  Features and Advantages: 
    variables
    partials
    import
    nesting
    mixins
    extend / inheritance
    operators

  * scss> $variable = #000000;          #use variables to to avoid duplication
  * scss> lighten($color,20%)           #use functions
    Functions:  see http://sass-lang.com/documentation/Sass/Script/Functions.html
      * lighten($color, $amount)
      * darken($color, $amount)
      * saturate($color, $amount)
      * desaturate($color, $amount)
      * grayscale($color, $amount)
      * complement($color, $amount)
      * invert($color, $amount)
  * Nesting
    css>  header {...}                  #replace two different nests
          header h1 {...}
    scss> header {...                   #with one next
            h1 {...}
          }         
  * Use a color partial
    * _colors.scss                        #PUT COLORS HERE - DRY principle
    * model.scss> $import 'colors'        #Import colors with this line.
  * Use normalize                       #normalize
  * application.css                     #MANIFEST (list) of your files
    !!! Order them carefully            #bottom overwrites top!
    * application.css> =require self                
    * application.css> =require normalize          
    * application.css> =require layout             
    !!! Gotcha
      Don't forget to add new model css's to the manifest file / application.css
      /* require new_model
  * Your compiled css file
    * http://localhost:3000/assets/application.css

## Bootstrap Basics
  Gemfile
    gem 'bootstrap-sass', '3.3'
    gem 'font-awesome-rails', '4.3'
    gem 'simple_form', '3.1.0'      # Great ready to go form styling.
    
  Retitle application.css to application.css.scss # Enable sass
  Replace file with
    @import 'bootstrap-sprockets';
    @import 'bootstrap';
    @import 'font-awesome';   # This really is awesome! Great icons.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Javascript
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Asset pipeline automatically loads all app/assets/javascripts/
      if //= require_tree . is active
    Turbo links is a rails program which only replaces the body and title
      unless it detects a change in the head file.
    In the manifest file application.js
      //= IS EVALUATED
      // (with no equals sign) IS NOT
    Avoid using inline <script> tags, because they slow the parser.
      Why? The rest of rails will run multithreaded, but javascripts
      only runs single threaded.
    Dynamic Loading is recommended / loading multiple JS files is not.
      What's that? Loading one file from another. See kehoe article.
  Main helper method
    javascript_include tag 

  Good Resouce
    http://railsapps.github.io/rails-javascript-include-external.html
  Gotcha?
    Don't have a the same file name for .coffee and .js. Only one will be
      precompiled.
    http://stackoverflow.com/questions/32140048/rails-asset-pipeline-is-not-loading-my-javascript-file-why-wont-this-code-work

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Users
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Gemfile> Uncomment bcrypt 
>        bundle install
>        rails g resource user name:string email:string password:digest
            admin:boolean
>        rails db:migrate
routes.rb> resources :users
user.rb> validates :name, presence: true
         validates :email, presence: true,
                           format: /\A\S+@\S+\.\S+\z/,
                              # \A start of string
                              # \S+ one or more non-white space 
                              # \.
                              # @ literal
                              # \z end of string
                              # test at http://www.rubular.com/
                           uniqueness: { case_sensitive: false }
console> add an admin user
user view template
  <%= form_for(@user) do |f| %>
      <fieldset>         # fieldset draws a box around things
                         # useful for related form elements
        <%= render "shared/errors", object: @user %>
        <%= f.label :name %>
        <%= f.text_field :name, size: 40, autofocus: true %>
        <%= f.label :email %>
        <%= f.email_field :email, size: 40 %>
        <%= f.label :password %>
        <%= f.password_field :password, size: 40 %>
        <%= f.label :password_confirmation, "Confirm Password" %>
        <%= f.password_field :password_confirmation, size: 40 %>
        <%= f.submit %>
      </fieldset>
  <% end %>
users_controller.rb
  # Restrict user access to users except for new and create
  before_action :require_signin, :except => [:new, :create]
  # Restrict user edit, update, destroy to the correct users
  def create
    set_user #@user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id      ###!!! This is techie for "logged in".
      redirect_to @user, :notice => "Thanks for signing up."
    else
      render :new
    end
  end

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Session
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Concept
  Session is the technical term for Logged In.
  It only has three actions: new, create, destroy
  The login (session info) is stored in a cookie, not the database.
Technical info:
  A series of requests from the time a user signs in to signs out.
  A session hash hold the user_id. {user_id}. Rails stores the session hash
  in a cookie which gets shuttled back and forth from app to user.
  Store anything_you_want in session[:anything_you_want]
    Don't forget to set the above back to nil on the log out.

The session gets it's own controller and actions: [new, create, destroy]
Step List
  routes> resource :session   #singular gets no :id column
                              #typically used for non-database items
  _header.html.erb> link_to 'Sign In', new_session_path
  >rails g controller sessions  #notice controller still gets the plural.
  sessions_controller> #define new action
  new.html.erb>   #notice you use the simpler tag version of form helpers
    <%= form_tag session_path do %>                                                                     
      <fieldset>
        <p> 
          <%= label_tag :email %>
          <%= email_field_tag :email, nil, :autofocus => true %>
        </p>        
        <p> 
          <%= label_tag :password %>
          <%= password_field_tag :password, nil %>
        </p>
        <p> 
          <%= submit_tag "Sign In" %>
        </p>
      </fieldset>
    <% end %>

  session_controller>
    def create
      #this line below works because User.authenticate returns the user object
      #it's NOT an equality, if proceeds as long as it doesn't get nil or false
      #if will proceed if it gets 0 (an integer)

      if user = User.authenticate(params[:email], params[:password])
        session[:user_id] = user.id
        redirect_to user, :notice => "Welcome back, #{user.name}!"
      else
        flash.now[:alert] = "Invalid email/password combination!"
        render :new
      end
  user.rb>
    def self.authenticate(email, password)
      user = User.find_by(:email => email)      
      user && user.authenticate(password)  #both will return nil or the user object
    end

  application_controller>
      # ||= is called memoization, it's a performance improver
      # everything after the ||= is saved in an instance variable
      # to avoid hitting the database 
      # an instance variable must be used, not a local variable
      # The line below works, but hits the database every time it's called
      # User.find(session[:user_id]) if session[:user_id]             

        class ApplicationController < ActionController::Base
        private
          def require_signin
            unless current_user
              redirect_to new_session_url, alert: "Please sign in first!"
            end
          end

          def current_user
            @current_user ||= User.find(session[:user_id]) if session[:user_id]
          end

          #give helpers access to controller methods with the following
          helper_method :current_user
        end
  
    _header.html.erb>   #Use logic to set up your header
      <nav>
        <p>
          <% if current_user %>
            <%= link_to current_user.name, current_user %>
          <% else %>
            <%= link_to 'Sign Up', signup_path, class: 'button' %>
            <%= link_to 'Sign In', new_session_path, class: 'button' %>
          <% end %>
        </p>
      </nav>

#Setup Users and Authentication (High Level)
  Users - Have Users be able to log in and log out.
  1) Generate a users resource with name, email, password_digest, and admin
    1b) Add a migration to have the users admin default to false.
  2) Validate presence, uniqueness, and email syntax (password is optional)
  3) Define a class level authentication method
      to run bcrypts user.authenticate(password)
      (email, password) -> user
  4) Setup user controllers with no restrictions for now
      

  * The Session hash (stored in cookie) stores user_id
  * require_sign allows continuation, or redirects_to new_session_url 
    - it runs current_user()
        which checks session[:user_id]? and returns@user or nil 
    - it also sets session[:intended_url] based on request.url
  * session_new (login) redirects to intended url, or re-renders itself
  * require_admin allows continuation or redirects_to root_url
      after checking the user.admin attribute

  Nifty method
    def admins_only(&block)
      block.call if current_user.try(:admin?)  # try returns nil, instead
    end                                        # of returning an exception
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Most Popular Gems
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
acts_as_list            #manage objects with positions
will_paginate           #pagination
exception_notification  #send emails when errors occur
paperclip               #manage files uploaded via web forms
carrierwave             #manage files uploaded via web forms
delayed_job             #queue tasks to run later
friendly_id             #semantic URLs
activemerchant          #credit card processing

Search for gems on http://rubygems.org
Add to your gemfile like this gem'yourgem', '~> x.x.x' #only grab patches
  or
Add to your gemfile like this gem'yourgem'  #grab all latest versions

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CoffeeScript
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Basics
  Part of NodeJS
  # Comment
  ### 
    Multiline Comments
  ### 
  No vars, no ; 
  Use white space replaces brackets
  Basic JS works
    name = "Phil"
    element = document.getElementByID("elementID")
    element.innerHTML = "Hello #{name}.<br>"
    element.insertAdjacentHTML('More stuff.<br>')
  boolean options
    my_boolean = true | yes | on
    my_boolean = false | no | off
  math
    element.innerHTML = "2 + 2 = #{2 + 2}"
  round - use toFixed(2) # 123.456 => 123.46
  increment / decrement : ++i, i++, --i, i--
  if age >= 16
    element.innerHTML = "#"
  CoffeeScript: square = (x) -> x * x  # Compiles to the following.
  Javascript:
    var scaure;
    square = function(x) {
      return x * x
    }
    # square => var square
    # =   => square =
    # ->  => function()
    # (x) => x             arguments
    # x * x => return x * x

coffeescript: 
  hello_world = () -> "Hello World"

javascript
  var hello_world;

  hello_world = function() {
    return "Hello World";
  };

coffeescript: 
  add (x,y) -> x + y

javascript
  var add;
  add = function(x,y) {
    return x + y;
  }

