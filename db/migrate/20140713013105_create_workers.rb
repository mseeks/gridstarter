class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.belongs_to :project, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
