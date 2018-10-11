require 'test_helper'

class DataEncryptingKeysControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "rotate url" do
    assert_generates rotate_data_encrypting_keys_path,
                     controller: "data_encrypting_keys", action: "rotate"
  end

  test "status url" do
    assert_generates rotate_status_data_encrypting_keys_path,
                     controller: "data_encrypting_keys", action: "status"
  end

  test "get #status" do
    get :status
    assert_response :success
  end

end
