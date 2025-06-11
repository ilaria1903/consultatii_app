class UpdateMesajColumnNames < ActiveRecord::Migration[7.1]
  def change
    rename_column :mesaj, :id, :id_mesaj
    rename_column :mesaj, :chat_id, :id_chat
    rename_column :mesaj, :sender_id, :id_sender
    rename_column :mesaj, :content, :continut
    rename_column :mesaj, :sent_at, :trimis_la
    rename_column :mesaj, :tip, :tip_continut
  end
end
