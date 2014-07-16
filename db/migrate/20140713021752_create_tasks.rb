class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :worker, index: true
      t.string :uid
      t.float :progress

      t.timestamps
    end
  end
end
