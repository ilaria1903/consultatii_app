class UpdateChatColumnNames < ActiveRecord::Migration[7.1]
  def change
    rename_column :chat, :id, :id_chat
    rename_column :chat, :consultatie_id, :id_consultatie
    rename_column :chat, :started_at, :chat_inceput_la
    rename_column :chat, :ended_at, :chat_incheiat_la

    add_column :chat, :status_chat, :string, default: "activ", null: false
  end
end
