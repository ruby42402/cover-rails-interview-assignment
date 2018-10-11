class RotateWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed, on_conflict: :raise, retry: false

  def perform(*args)
    if old_primary_key = DataEncryptingKey.primary
      old_primary_key.update_attributes(is_primary: false)
      new_primary_key = DataEncryptingKey.generate!(is_primary: true)
      EncryptedString.all.each do |e|
        e.set_new_data_encrypting_key(new_primary_key)
      end
      old_primary_key.destroy!
    end
  end
end
