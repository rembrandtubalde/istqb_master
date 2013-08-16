class SetDefaultsForFields < ActiveRecord::Migration
  def change
    change_column :users, :is_superuser, :boolean, :default => false
    change_column :users, :certificate_type, :string, :default => "CTFL"
  end
end
