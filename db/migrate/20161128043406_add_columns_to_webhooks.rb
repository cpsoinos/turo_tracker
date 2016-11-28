class AddColumnsToWebhooks < ActiveRecord::Migration[5.0]
  def change
    add_column :webhooks, :remote_id, :string
    add_column :webhooks, :webhook_type, :string
    add_column :webhooks, :location, :jsonb
    add_reference :webhooks, :vehicle, foreign_key: true
  end
end
