class CreateWebhooks < ActiveRecord::Migration[5.0]
  def change
    create_table :webhooks do |t|
      t.string :integration
      t.jsonb :data
      t.timestamps
    end
  end
end
