class ReplacePrimaryKeyInUtilizatori < ActiveRecord::Migration[7.1]
  def up
    execute("ALTER TABLE utilizatori DROP CONSTRAINT utilizatori_pkey CASCADE;")

  end

 
end
