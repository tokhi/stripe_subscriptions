# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :stripe_id
      t.string :customer_id
      t.string :status
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
