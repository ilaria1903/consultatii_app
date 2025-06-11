class CreateSpecializariFix < ActiveRecord::Migration[7.0]
  def change
    create_table :specializari do |t|
      t.string :nume, null: false
      t.timestamps
    end
  end
end
