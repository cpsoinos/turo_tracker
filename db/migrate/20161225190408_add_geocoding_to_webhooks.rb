class AddGeocodingToWebhooks < ActiveRecord::Migration[5.0]
  def change
    add_column :webhooks, :latitude, :float
    add_column :webhooks, :longitude, :float
  end
end
