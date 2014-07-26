class AddSshPublicKeyAndSshPrivateKeyToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :ssh_public_key, :text
    add_column :workers, :ssh_private_key, :text
  end
end
