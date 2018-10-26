# Rails Back End

## Overview

1.  Object Orientation (OO)
2.  Object Relational Mapping (OO -> SQL)
3.  Databases (SQL)
4.  Serialization (An Alternative Strategy)

---

### Store one built-in => One table, add column

Eg) Is User an admin? Add admin column.

### Store one object => Two tables, child table has foreign key.

Eg) Account **has_one** :accountHistory

### Store lists of built-ins => Two Tables, child built-in table has foreign key.

Eg) Users have a list of favorite websites. Make favorite_website object with an account_id foreign_key. \*Note: favorite_websites are not considered a full fledged OO object. If that's the case see next item.

### Store lists of objects (which return back) => Three Tables

Students take different classes. Classes have different students. Make a two objects and one join table.

## Overview of Associations

**Migrations make and manage the database tables.**  
**Associations tell the rails object which tables and columns to use.**

## Understanding Association Options

### has_many

```ruby
class Person                 # In rails the class always maps to a table
                             #   with a pluralized version.
                             # Queries on a person instance will trigger
                             # lookup on the persons table.
  has_many :doodads,         # NAME OF METHOD, WHEN doodads is called...
    :class_name => :stuff,   # goto the STUFF table
    :foreign_key => :user_id # goto the user_id column, and look in their
                             # for person's key.
# Eg
# Person.new (eg: id = 7 ) has a doodads method
#   which goes to the stuff table
#   and checks the :user_id column for "7" (it's id) to build
#  the list of doodads.
```

### belongs_to

```ruby
class Stuff
  belongs_to :owner             # NAME OF METHOD
    :class_name => :person      # CLASS NAME
    :foreign_key => :person_id  # COLUMN NAME
```

Eg) When Stuff.new.owner is called go get the key from the
:person_id column, and then return Person.find(:person_id)

Gotcha: be really careful with belongs_to, :dependent => :destroy
This will go up the association tree and continue following
along all 'dependent-destroys'.

## Design

Object Oriented -> RAILS Object Relational Mapping / Mismatch

1.  Built-ins -> Map directly to tables, idiosyncratic
    (string -> varchar (limit to length 255)
    Eg) User; attr_reader :name -> users table with name column
2.  Collections -> Serialization or Associations
    _. Serialization: not recommended, slow, but does store order, uses YAML  
     Eg) Person; favorite_foods = ["pizza", "popcorn"] -> persons table with favorite_foods column with ["pizza", "popcorn"].to_yaml in it  
    _. Separate Tables / Associations: recommended, fast, does not store order, use filters  
     Note that it is the child table which references the parent. The parent does not need to reference the child table (other than the method has\_\*)

3.  Basic - all this quantification is necessary for speed

- One-to-one
- One-to-many
- Many-to-one
- Many-to-many

2.  Through: convenience methods for bypassing join table

3.  has_and_belongs_to_many - if no join table is needed, you can use this convenience method

4.  Inheritance -> Single Table Inheritance, a separate object tables are in one table which now has a type column.

5.  Composition -> **Polymorphic** A _join_ table which stores foreign*ids \_and* foreign_types

```ruby
class Avatar
  belongs_to :avatarable, :polymorphic => true
class Player
  has_one :avatar, :as => :avatarable
class Monster
  has_one :avatar, :as => :avatarable
```

### avatars table

| id  | name             | avatarable_id | avatarable_type |
| --- | ---------------- | ------------- | --------------- |
| 1   | meditation_image | 5             | player          |
| 2   | fighting_image   | 7             | monster         |

---

# SQL

---

## Basic Syntax

## Working With Users

## Working With Databases

```sh
> rails db
```

```sh
sqlite> .schema                 # output all schemas
sqlite> .schema models          # output schema for models table
```

## Working With Columns

## Searching The Database

## Report Filtering

## Questions

### !!! model.select is database expensive!!! creating a db hit for every record.

### !!! Do not put queries in the controller

Make a method in the model
model>def self.myquerymethod
model> where('attr > 1000').order('attr asc')
model>end
controller>@Models = model.myquerymethod

(http://guides.rubyonrails.org/active_record_querying.html)[API for Active Record Querying]

# Migrations

## Gotcha

- Whenever you make a new migration, do a rollback, to make sure you haven't broken something.
  ```sh
    >rails db:rollback                      #Revert database 1 step
    >rails db:migrate                       #Back to the latest
  ```

## Quick Reference

Code lives in `ActiveRecord::Migration`

- API for change|up|down methods: [TableDefinition](http://api.rubyonrails.org/v5.1.2/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html) _(long form methods for working with schema)_
- API for the `create_table` object: [Table](http://api.rubyonrails.org/v5.1.2/classes/ActiveRecord/ConnectionAdapters/Table.html) _(create table convenience methods)_
- API for the `change_table` object: [SchemaStatements](http://api.rubyonrails.org/v5.1.2/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html) _(change table convenience methods)_

## Description

Migrations are Rails' DSL for managing database schema agnostic of any specific database (like JQuery handles browser details, Migrations handle database details).

## What's the difference between `rails g migrate|model|resource|scaffold` ?

- `migrate` works solely with database tables.
- `model` creates database tables, _and_ makes a model (for defining relationships).
- `resource` does the first two, and makes a controller.
- `scaffold` does the first two, makes a controller and 7 views.

### Common Table Methods

- `create|change|rename|drop_table`  
  Notice that create and drop are antonymns.
  Note: Heroku doesn't like destructive acts (like drop_table).
  If you're sure, specify `drop_table <table>, :force => :cascade`

### Common Column Methods

- `add|change|rename|remove_column`  
  Notice that add and remove are antonymns.

### Common Index Methods

- `add|remove_index`

---

# New Tables

---

## Command Line Migrations

Make a model. Primary id is automatic.

```bash
  > rails g migration model <column>:<datatype> ...
  > rails g migration user first_name:string last_name:string
```

Include indexes.

```bash
  > rails g migration model name:string:index color:string:index
```

Make a HABTM Join Table. Indexes are **not** the default.

```bash
  > rails g migration createJoinTableParentsStudents parents students
```

```ruby
  create_join_table :parents, :students do |t|
    t.index :parent_id
    t.index :student_id
  end
```

Add a new foreign key to an existing table

```sh
 > rails g migration AddUserToUploads user:references
```

Tweak migration like so.

```ruby
  class AddUserToUploads < ActiveRecord::Migration
    def change
      add_reference :uploads, :user  # Index is default.
      add_foreign_key :uploads, :users # Adds constraint to *existing* column!
    end
end
```

---

# Changing Tables

---

## Naming: put <table> in suffix

Changes

```bash
  > rails g migration addAdminColumnToUsers
```

Add Column

```bash
  > rails g migration Add<Column>To<Table> <column>:<datatype> ...
  > rails g migration AddPartNumberToProducts part_number:string
```

Remove Column

```bash
  > rails g migration Remove<Column>From<Table>
  > rails g migration RemovePartNumberFromProducts
```

#### `:from` and `:to`

Use from and to to enable roll backs.

```ruby
  change_table :models do |t|
    t.change_default(:column, :from => nil, :to => "...")
```

## Seeding

Concept put in default data into your database
app/db/seeds.rb> put in create date in a hash

> rails db:reset #clear database _and_ run db:seed the database
> rails db:seed #seed data (it's additive), run twice and you'll have double data

                        #note db:reset runs this for you.

> rake db:drop db:create db:migrate

                        #purge your database and return to current schema

---

Naming convention: use yourMigrationChangesToTablename /
your_migrations_changes_to_tablename Rails will select the tablename in the
suffix. If you don't name it that, you can select the table yourself in the
migration file.

Question:
When do you use a >rails g migration|model|resource|scaffold ?
Answer:
You need to think ahead for what you need.
A migration updates your database tables.
A model updates your database tables, and makes a model (for defining relationships).
A resource does the first two, and makes a controller.
A scaffold does the first two, makes a controller and 7 views.

Common Commands

```sh
> rails g migration model name:string color:string
> rails g migration addAdminColumnToModel
> rails g migration setDefaultsToModel
```

## Seeding

Migrations also handle database seeding in a `seeds.rb` file.
Insert any Ruby database creation code & run `rails db:seed`

```ruby
5.times { |i| Product.create(name: "Product ##{i}") }
```

---

## Validations

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

###ActiveRecord::Calculations
Rail methods for columns of a database
count (like length / size)
maximum, minumum
average
sum
calculate #long form of the above commands
ids #return an array of column id's
pluck #return an array of column values

> class Model < ActiveRecord::Base #Model inherits form ActiveRecord
> rails g model mymodel name:string price:decimal #make mymodel and create database schema
> DATABASE TYPES:
> .string | text #string :limit = 255
> .integer | decimal | float #use decimal for up 38 digits
> .boolean | binary !!! For booleans, always set a default value. SQL

                        considers null, to mean unknown.

.date | time | datetime
.primary_key
.timestamp

> rake db:migrate #Rails 4,
> rails db:migrate #Advance database
> rails db:migrate:status #Check on database status
> rails db:rollback #Revert database 1 step
> cat db/schema.rb #look at the current schema

---

##Rails Console

> reload! #run this to refresh the console

##CRUD
Concept: Create, Read, Update, Destroy for Web Objects

###Create
Model.create, Model.find(#) | Model.find_by(attr: "string"), Model.update(), Model.destroy
Create objects and assign attributes individually

> e = Model.new #instantiate
> e.name = "Name" #assign attribute
> e.save #save to database

Create objects and assign with hash

> e = Model.new(name: "Name", price: 15.00)
> e = Model.new(:name => "Name", :price => 15.00) #same as above, alternate hash syntax
> e.save

Create and save in one step with a hash

> e = Model.create(name: "Name", price: 15.00)
> Model.create(name: "Name", price: 15.00) #Same as above, with a variable assignment

###Read

> count = Movie.count #return how many Movies there are.
> e = Movie.find(3)
> e = Movie.find_by(price: 15.00)
> e = Movie.all #returns an array of all table Models

###Update

> e.Event.find_by(price: 15.00)
> Model.destroy(3) #destroy by primary key using the Class method
> e.update(name:"Kata Kamp", price: 30.00) #writes the database

###Destroy

> e = Event.find(3)
> e.destroy

## Scope

Basic concept # A way to name a custom query
Why not a method? # Expressive, Syntactic Sugar  
 Like a method,but # enforces correct # of arguments, and # supports defaults
scope :name, lambda { sql } # Two parameter method
scope :name, -> () {} # Rubyists prefer this syntax.
scope :name, -> (name=default) {name} # Pass in argument(s)
scope :past, -> { where('starts_at <?', Time.now).order(:starts_at)}
scope :recent, -> (max=3) { past.limit(max) }
console> Model.scopename
console> Model.recent(3)
console> Model.hits.where("total_gross > 4000000") #chain sql
console> Model.hits.recent #chain scopes
console> user.favorite_movies.hits #chain on through associations

# Adding an attribute column

# Class Method

total = Model.scoped.pluck(:id).sum #not tested ~~~something like this

# Collection Method

total = @items.map(&:id)

##Advanced
#Use a lambda in the model declaration to adjust how a model is ordered
model.rb> has_many :reviews, :dependent => :destroy
model.rb> has_many :reviews, -> { order(created_at: :desc) },
:dependent => :destroy

##Gotcha
scope :name, lambda sql #gotcha! you need a block {}

##Database Question
When I set up :dependent => :destroy on a through model,
is the opposing model destroyed, or only the join model?
Answer: only the join.

## RELATIONSHIPS / ASSOCIATIONS

Foreign Keys
Child objects always get the foreign key
Names are always singular, eg) foo_id, parent_id
Non-conventional foreign keys can be set with { :foreign_key => foo_id }
in the model file.
Foreign keys can reference different columns, eg
author_id can contain #{user.id} Rails4InAction, pg 164

console> delete versus destroy
delete leaves orphans
eg) parent.child.delete (leaves an orphanted child object)
destroy will set the foreign key to nil and destroy the child object
eg) parent.child.destroy (deletes the child objects
nullify, deletes the parent, and sets the child foreign key to nil.
!!! Gotcha doesn't work on sqlite, does work on Heroku Postgres
Rails 5 does not allow the creation of orphaned child objects
Rails 5 also runs a _save_ on new child objects if you set a foreign key

##One-to-many | 1:M >rails g resource child attr:string parent:references
(migration> t.references :parent, foreign_key:true)
#'t.references :parent' addes the parent_id
#'foreign_key: true' requires a valid parent_id
childmodel> class Child <ActiveRecord::Base
belongs_to :parent
end
parentmodel> has_many :registrations, dependent: :destroy #notice the colon in :destroy
#dependent: :destroy is necessary or there will be orphaned children

    # has_many creates the child methods, as well as the build method

###New Methods >parent.children #lists children objects >child.parent #lists parent object >child.parent_id = index_number #two ways to set >child.parent = parent_instance #convenience method, same as above

###Gotcha!
Work in your console to make sure everything is working before you switch to UI setup.
controller> @child = Child.new #don't do this, reference the use the parent relationship
controller> @child = parent.children.new #This sets the foreign key for you!

---

## Associations ( ActiveRecord::Associations::ClassMethods )

### What Are They?

They map the relationship of object-oriented models to the relationship of database tables.

### Why Use Them?

They save a lot of manual work (SQL searches) by providing convenience methods.

### How Do They Work?

Each model gets a primary key. A model may reference another by name and primary key.
Since almost all models have their own primary key, a reference to another model is called a
foreign key.

If you are familiar with the idea of dependency injection - this is like
dependency injection for databases - instead of trying to piecemeal another model's data
into another, your just provide reference to the whole table.

### Common Cases

#### Ex 1) A an Account has an AccountHistory

This is a simple 1-to-1 association. `belongs_to` is the main method. `belongs_to`
always indicates singular ownership.

#### Ex 2) Lots of Students and lots of Classes

This is a Many-to-Many (M-to-M) association. The most likely situation is that
the join table, let's call it Registrations will have additional information. This
will be setup using `has_many <association> :through :registrations` on both models.
Normally accessing each table would require it's own database hit, but by using
`:though`, only one database his is used.

#### Ex 3) Users "like" Movies.

Since no information is necessary in the join table, this should be set up as a
`has_and_belongs_to_many` relationship. Note the join table gets no primary key.

#### Ex 4) An Phone is used by multiple models, such Student and Teacher

Setup Phone as `belongs_to :polymorphic => true`. This adds
a foreign*key \_and* a foreign_key_type. To quote the rails guide: "think of a
polymorphic `belongs_to` declaration as setting up an interface that any other
model can use."

````sh
> rails g scaffold student name
> rails g scaffold teacher name
> rails g model phone number owner:references{polymorphic}  # <--- Important
> rails db:migrate

The phones table now has a :owner_id and a :owner_type column.

```ruby
  Phone < ActiveRecord::Base
    belongs_to :owner, :polymorphic => true, :optional => true

  Student < ActiveRecord::Base
    has_many :phones, :as => :owner

  Teacher < ActiveRecord::Base
    has_many :phones, :as => :owner
````

#### Ex 5) An Employee table holds references _Within Itself_ to Managers

Tables referring to themselves is allowed. This is handled by passing
the tables own name to "class_name". In the example below a `manager_id` refers to the `employee_id` of the manager. The unusual foreign_key declaration (it's usually an option on the child model), broadcasts the name of the foreign key column, since it normally matches the table name "employee_id".

```ruby
class Employee < ApplicationRecord
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee"
end
```

#### Commands

##### `build`

- Build a convenience command for Model.new
- `belongs_to` uses `build_association`  
   Eg) account.build_account_history( ... )
- `has_many` uses `collection.build`
  Eg) author.books.build( ... )

````
##### `inverse_of`
 example:
    Whole
      has_many :parts, :inverse_of => :whole
    Part
      belongs_to :whole, :inverse_of => :parts
  Weird issue -
    when checking for validations - use :school, not :school_id (for a child relationship)
    inverse_of is compensating on the method level, not the db level.

 * Rails will normally work bidirectionally assuming normally
 named items (database hit = 1), except for
 :through, :polymorphic / :as, :class_name, :foreign_key, and :conditions.

:through and :polymorphic / :as cannot be remedied,
but  
:class_name, :foreign_key, and :conditions can be remedied by using :inverse_of

:inverse_of is an option on `has_many`
```ruby
  class Author < ApplicationRecord
    has_many :books, inverse_of: 'writer'
  end

  class Book < ApplicationRecord
    belongs_to :writer, class_name: 'Author', foreign_key: 'author_id'
  end
````

    > rails g migration CreateMediaJoinTable artists musics:uniq
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

                  movie.fans << user                           # Right
                  movie.favorites << user                      # Wrong

                  user.favorites.create(movie: movie)          # Right
                  user.favorites_movies.create!(movie: movie)  # Wrong

                  user.favorite_movies << movie                # Right
                  user.favorites << movie                      # Wrong

```

```

### Destroy Versus Delete

- Destroy cascades.
- Delete does not cascade.

## Credits

Understanding Same Table Associations:
https://www.spacevatican.org/2008/5/6/creating-multiple-associations-with-the-same-table/

## Memoization

Basic Technique
Create an instance variable, will last for the request (one screen)

```ruby
def my_expensive_calculation
  @my_expensive_calculation ||= foo
end
```

Gotcha! Class level memoiazations are stored in memory, creating
nasty bugs.

```
def class_level_memo
  @class_level_memo ||= User.expensive_calculation
end
```

Info: http://cmme.org/tdumitrescu/blog/2014/01/careful-what-you-memoize/
