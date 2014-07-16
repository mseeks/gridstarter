class AddUserIdToWorkers < ActiveRecord::Migration
  def change
    add_reference :workers, :user, index: true
  end
end
