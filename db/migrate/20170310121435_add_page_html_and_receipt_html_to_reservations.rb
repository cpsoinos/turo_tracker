class AddPageHtmlAndReceiptHtmlToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :page_html, :jsonb
    add_column :reservations, :receipt_html, :jsonb
  end
end
