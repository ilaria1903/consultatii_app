class CreateRoluri < ActiveRecord::Migration[7.1]
  def change
    create_table :roluri do |t|
      t.string :nume

      t.timestamps
    end
  end
end
