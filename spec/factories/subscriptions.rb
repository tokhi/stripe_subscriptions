# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    stripe_id { '123' }
    customer_id { '345' }
    status { 'unpaid' }
    start_date { Time.now }
    end_date { Time.now + 1.day }
  end
end
