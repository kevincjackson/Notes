class Cooking
    def self.boil_water( minutes )
      if ( minutes >= 5 )
        "done"
      else
        "not done"
      end
    end
end

require 'minitest/autorun'

class TestCooking < Minitest::Test
  def test_boil_water
    assert_equal( "not done", Cooking.boil_water( 3 ) )
    assert_equal( "done", Cooking.boil_water( 5 ) )
    assert_equal( "done", Cooking.boil_water( 10 ) )
  end
end
