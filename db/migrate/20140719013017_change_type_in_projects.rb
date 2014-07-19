class AddTypeToProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :type, :work_type
  end
end
