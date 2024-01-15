# Ruby Testing

The two most popular testing tools in Ruby are *minitest* and *Rspec*.  *Minitest* is a traditional testing tool (think `assert_equal(4, 2+2)`), and a part of Ruby's standard library, whereas *Rspec* focuses on humanizing the testing terminology (think `describe "numbers" ... "add correctly"`), and requires third party code. At the time of this writing Rspec is more popular with the Rails community.

## Example
Say you would like to test this code.
```ruby
# boil_water.rb
class Cooking
    def self.boil_water( minutes )
      if ( minutes >= 5 )
        "done"
      else
        "not done"
      end
    end
end
```

A quick test in *minitest* might look like this.
```ruby
# boil_water.rb
class Cooking
    def self.boil_water( minutes )
      if ( minutes >= 5 )
        "done"
      else
        "not done"
      end
    end
end

require 'minitest/autorun'   # automagically run tests

class TestCooking < Minitest::Test  # must inherit from the minitest library
  # !!! Testing methods MUST begin with "test_" or they won't run.
  def test_boil_water               # must have the prefix 'test_'
    assert_equal( "not done", Cooking.boil_water( 3 ) )
    assert_equal( "done", Cooking.boil_water( 5 ) )
    assert_equal( "done", Cooking.boil_water( 10 ) )
  end
end
```
```sh
>ruby boil_water.rb
Run options: --seed 17479
# Running:
.                 # The '.' indicates success.
Finished in 0.000878s, 1138.5618 runs/s, 3415.6855 assertions/s.
1 runs, 3 assertions, 0 failures, 0 errors, 0 skips
```
# TODO 
 * Layout production tests for minitest and rspec
   in test and spec directories.
 * Note: launch from root.
 * Note gem install for Rspec
 * Note major Rspec difference between 2 & 3


