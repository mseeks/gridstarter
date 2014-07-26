class AddSshFingerprintToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :ssh_fingerprint, :string
  end
end
