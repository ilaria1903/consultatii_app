class SchimbaParolaInPasswordDigest < ActiveRecord::Migration[7.0]
  def change
    remove_column :utilizatori, :parola, :string
    add_column :utilizatori, :password_digest, :string
  end
end
