require 'test_helper'
require 'sidekiq/testing'

class KeyRotateFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    Sidekiq::Testing.inline!
  end

  def teardown
    Sidekiq::Worker.clear_all
    clear_unique_from_redis
  end

  test "rotate keys" do
    example_string = "example_string"

    post encrypted_strings_path, encrypted_string: { value: example_string }
    assert_response :success

    example_token = JSON.parse(response.body)['token']
    old_primary_key = DataEncryptingKey.primary

    for i in 0..1000
      post encrypted_strings_path, encrypted_string: { value: "string_#{i}" }
      assert_response :success
    end

    post rotate_data_encrypting_keys_path
    assert_response :success

    get rotate_status_data_encrypting_keys_path
    assert_response :success

    new_primary_key = DataEncryptingKey.primary
    assert_not_equal(old_primary_key, new_primary_key)

    get encrypted_string_path(token: example_token)
    assert_equal(example_string, JSON.parse(response.body)['value'])
  end
end
