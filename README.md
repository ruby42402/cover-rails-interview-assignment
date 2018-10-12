1. Gem
* Added `sidekiq` and `sidekiq-unique-jobs`
* Commented out `spring` for testing `sidekiq` in development
* Added `sprockets-rails` for latest release
* Directed `aes` to another fork for `OpenSSL::Cipher::Cipher` warning

2. Controller
* Created `data_encrypting_keys` controller with `rotate` and `status` for each requested endpoint
* Used `sidekiq-unique-jobs` to avoid duplicate jobs
* Used `sidekiq` API to check if the job is in queue/in process
* Generated a `data_encrypting_key` if none existed before creating a new `encrypted_string`

3. Model
* Added the method `non_primary` to `data_encrypting_key` to get all old/unused keys
* Renamed method for `key` for `attr_encrypted` of `encrypted_string`
* Added `set_new_data_encrypting_key(new_key)` for updating to new key
* Modified `set_token` to avoid resetting `token`

4. Worker
* Created a `rotate_worker`

5. Config
* Added routes for endpoints
* Added `sidekiq.rb` initializer to cleanup `sidekiq-unique-jobs` dead locks

6. DB
* Renamed `primary` to `is_primary` since `primary` is a reserved key on postgresql
* Added `encrypted_key_iv` to `data_encrypting_keys`

7. Test
* Tests for routes and endpoint response
* Tests for checking the value and the key of created `encrypted_string`
* A test for checking updated value and key after setting a new key
* Tests for whether queuing one job is fine and whether queuing two jobs is not fine
* The integration test
