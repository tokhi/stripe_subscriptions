# frozen_string_literal: true

class SubscriptionCreatedJob < ApplicationJob
  queue_as :default

  def perform(**args)
    process(**args)
  end

  def process(subscription:)
    Subscription.create(
      stripe_id: subscription.id,
      customer_id: subscription.customer,
      status: 'unpaid',
      start_date: Time.at(subscription.current_period_start),
      end_date: Time.at(subscription.current_period_end)
    )
  end
end
