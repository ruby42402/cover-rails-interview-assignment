require 'test_helper'

class EncryptedStringTest < ActiveSupport::TestCase

  setup do
    @key = DataEncryptingKey.generate!(is_primary: true)
    @encrypted_string = EncryptedString.new(value: 'test_case')
  end

  test 'check key' do
    assert_equal(@encrypted_string.data_encrypting_key, DataEncryptingKey.primary)
  end

  test 'set new key' do
    assert_equal(@encrypted_string.data_encrypting_key, @key)
    old_value = @encrypted_string.value
    new_key = DataEncryptingKey.generate!(is_primary: true)
    assert_not_equal(@key.id, new_key.id)
    @encrypted_string.set_new_data_encrypting_key(new_key)
    assert_equal(@encrypted_string.data_encrypting_key.encrypted_key, new_key.encrypted_key)
    assert_equal(@encrypted_string.value, old_value)
  end
end
