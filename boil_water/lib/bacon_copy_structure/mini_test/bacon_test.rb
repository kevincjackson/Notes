require "minitest/autorun"

class Bacontest < Minitest::Test
  class Bacon
    def self.saved?
      true 
    end
  end

  def test_saved
    assert Bacon.saved?, "Bacon not saved!"
  end
end
