require 'test_helper'

class DataEncryptingKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test ".generate!" do
    assert_difference "DataEncryptingKey.count" do
      key = DataEncryptingKey.generate!(is_primary: true)
      assert key
    end
  end
end
