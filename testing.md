---
# Testing
---
## Development Types
  * Error Driven: What We Want, Error, Fix
  * Test First: What We Want, Error, Fix: Same as above + below concepts
  * TDD / BDD (Fail, Pass, Refactor _or_ Red, Green, Refactor)
     * Provides regression testing - testing focused on verifying previously
    developed and tested software still performs correctly.
     * Clarify what a feature should do
     * Focus on measurable goal
     * Make change with confidence
     * Faster workfow
  * Agile -  A an iterative development methodology focusing on finishing one feature at 
  a time before moving on to the next feature.
  * Story Driven Development - BDD with an emphasis on things a user can do with the system.
  
 ## Types of Tests
  * Unit Tests : test Models : test::unit
    * Use to test all business logic
    * Use to test corner cases
  * Functional Tests - test Views & Controllers
  * Integration Tests - test workflows, user stories, sequence of requests
  * Feature / Acceptance Test - test user expectation 
    * Use to test happy path of a feature 
    * not to corner cases 
    * high level black box tests.
  * Performance Testing - test speed of requests handled
  * Load Testing - now many requests can be handled
  * Security Testing - test for security vulnerabilities
    
## Testing Tools
  * MiniTest - pure Ruby, standard
  * RSpec - DSL for business 
    * Gotcha: Note it's RSpec, not Rspec !
  * Test::Unit (Rails out the box)
  * Cucumber (out of favor)
  * Shoulda
  * Capybara - Acceptance Test program designed to web interaction
  * FactoryGirl - provides a singular source for creating test models, to
      address your tests breaking as your model changes.

## FactoryGirl 
spec/factories/ticket_factory.rb>
  ```ruby
    FactoryGirl.define do
      factory :ticket do
        name "Example Ticket"
        description "An example ticket, nothing more"
      end
    end
  ```

## Rails Workflow
  * Install RSpec and Capybara
  * setup the project to use Rspec
  * create a feature spec file
  * use example groups to group related code examples
  * write code examples with expectations
  * run automated specs
  
##Gotchas
>spring stop (another rails is running in bg)
>rails generate rspec:install
>gem uninstall rspec-rails capybara

!!! Horrible time wasting name space collision with user_attributes.
I had pasted sample code down below and forgotten about it! It was
overwriting my production code! 
  !!! Next time, put in comments !!!
## Rspec

### Setup
Gemfile
```ruby
group :test :development do
  gem "rspec-rails", "3.5.0.beta3"
end
group :test do
  gem "capybara", "2.7.1"
end
```
```bash
>bundle install
>rails generate rspec:install
>rspec                              #check to see if it runs
  # disable stubs - very annoying auto generating files
>config/application.rb> config.generators { |g| g.test_framwork false }
(>rails g controller name --no-test-framework)
>mkdir spec/{controllers, features, models, support} as needed
>New files must be name *_spec.rb.
```

##Basics
    Docs:
      https://github.com/jnicklas/capybara#the-dsl
    specfile> require 'rails_helper'
    app_root> rspec spec --format documentation  #Show passing tests.
    .rspec> --color                 #color code test red / green
            --format documentation  #verbose
    High Level Concept: 1) Arrange (Setup data) 2) Act (visit_page) 3) Assert (expect)
    specfile> 
```ruby
              # There's also subject {} where you can define the main
              # purpose of your test, 
              # eg) subject { ProjectPolicy }
              # eg) subject { ProjectPolicy.some_method }
            
              describe "high level feature" do
                  examples: [Viewing $somepage, navigating, a model]
              describe "Navigating projects" do
                #to run before multiple it methods
                before :each do
                  User.create(email: 'user@example.com', password: 'password')
                end 
  
                # Let provides a function definition
                let(:project) { Factory.Girl.create(:project) }
                let(:ticket)  { Factory.Girl.create(:ticket, project: project) }
                  # let is lazily loaded
                  # let! is immediately loaded
                before do
                  visit project_ticket_path(project, ticket)
                  click_link "Edit Ticket"
                end

                #capybara has make method???
                it "does something" do
                it "allows navigation from the detail page to the listing page"
                it "allows navigation from the listing page to the detail page"
                it "shows the total gross if the total gross exceeds $50M"
                it "shows 'Flop!' if the total gross is less than $50M"
                
                  #Arrange
                  user = User.create!(user_attributes)
                  visit page_url

                  #Act
                  fill_in "First Name", :with => "John"
                  fill_in "project_name", :with => "Sublime"    # uses label
                  fill_in "project[name]", :with => "Sublime"   # uses id
                    # try to use the label version to stay on higher abstraction level.
                  click_link "Index"
                  click_button "Sign in"
                    !Gotcha, don't forget to click buttons!

                  #Assert
                  within("#ticket h2") do  # within(css selector) limits your
                                           # search to the specificied css selector
                                           # Cool!
                    expect(page).to have_content "Make it shiny!"
                  end
                  expect {click_button "Submit"}.not_to change(User, :count)
                  expect(current_path).to eq(movies_path)
                  expect(current_path).to eq(user_path(User.last))
                  expect(page).to         have_text "text"
                end
              end
```



---
### Stubbing

#### What is stubbing?

Stubbing is when an object, real or test double, returns a known value in response to a message.

#### When do you stub?

Imagine a game which has a `die` object, which returns random numbers based on it's `roll` method. You would like to test the `player` object based on the effect of different die rolls.  The stub gives you the ability to fake the die rolls as needed.

Stubbing is ideal for unit testing.

Stubbing should not be used for feature testing.

#### Why do you stub?


Stubbing eliminates false failures.
  For example, if every test that relied on a login, used an actual
  login, every test for fail, even if the logic they were testing 
  was correct.  With stubbing, only the login logic would fail.

#### How do you stub?

You use the `allow` and `receive` methods.

```ruby
describe "die" do
  it "rolls a three" do
    die = Object.new
    allow(die).to receive(:roll) { 3 }
    expect(die.roll).to equal 3
  end
end
```

#### How do you stub chained methods?

Use the methods `allow` and `receive_message_chain`.

```ruby
allow(double).to receive_message_chain("foo.bar") { :baz }
```

Simulates the following:

```ruby
double.foo.bar # => :baz
```

### Testing Controllers with stubbing

```ruby
    require 'rails_helper'

    RSpec.describe Admin::ApplicationController, { :type => :controller } do
    
      let(:user) { FactoryGirl.create(:user) }
    
      before do
        allow(controller).to receive(:current_user).and_return(user)
      end
    
      context "non-admin users" do
        it "are not able to access the index action" do
          get :index
          expect(response).to redirect_to "/"                                                                                                      
          expect(flash[:alert]).to eq "You must be an admin to do that."
        end
      end
    
    end
```
---

## Custom RSpec Method

```ruby
it "should permit the show action" do
  expect(subject).to permit_action :show
end
```
Can be replaced by
```ruby
it { should permit_action :show} # *or* 
it { is_expected.to permit_action :how}
```
You can use a custom RSpec matcher to define permit_action

##Unit testing (tests on Classes and Models)
    Don't do math yourself.
    Let your test get the initial value and do math for you.
    Use @instance variables.

##Context if for setting different before initializers.
    Example say you initialize most of your test by setting all variables,
    but you set a few with defaults.

##Validation Specs
    rails method> any?    #>=1
    rails method> many?   #>1
    spec> it "conversation description" do
            model = Model.new(attr: "")
                                      #!!! Must run the valid? method!
            model.valid?              #rails method return true/false, faster than hitting the database
            expect(model.errors[:attr].any?).to eq(true)
          end
##Rspec Versions
    Version 2
```ruby
      @model.should == '...'
```
Version 3
```ruby
      expect(@model).to eq('...')
      expect(@model).not_to eq('...')
```
###Gotchas
    Silence output 
      $stdout = StringIO.new  #ruby accesses stdout in $stdout
                              #StringIO.new takes the string
                              #instead of stdout

Support Directory
  To keep your testing code dry
  1) Create a support directory
  2) In the rails_helper file uncomment this line
     24 Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }             
  3) Add support methods to a file.
      Eg) user_support.rb>
