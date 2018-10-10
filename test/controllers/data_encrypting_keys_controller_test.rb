require 'test_helper'
# require "redis"

class DataEncryptingKeysControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

=begin
  teardown do
    clear_unique_from_redis
  end
=end

  test "rotate url" do
    assert_generates rotate_data_encrypting_keys_path,
                     controller: "data_encrypting_keys", action: "rotate"
  end

  test "status url" do
    assert_generates rotate_status_data_encrypting_keys_path,
                     controller: "data_encrypting_keys", action: "status"
  end

  test "post rotate once" do
    post :rotate
    assert_response 200
  end

=begin
  test "post rotate more than once" do
    for i in 0..1
      sleep 1
      post :rotate
    end
    assert_response 202
  end
=end

  test "get #status" do
    get :status
    assert_response :success
  end

end
