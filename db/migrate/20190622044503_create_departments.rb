class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name
      t.text :desc
      t.integer :parent_id

      t.timestamps
    end
  end
end
