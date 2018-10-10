class RenamePrimaryToIsPrimary < ActiveRecord::Migration
  def up
    rename_column :data_encrypting_keys, :primary, :is_primary
  end

  def down
    rename_column :data_encrypting_keys, :is_primary, :primary
  end
end
