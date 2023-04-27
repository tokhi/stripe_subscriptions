# frozen_string_literal: true

class InvoicePaymentSucceededJob < ApplicationJob
  queue_as :default

  def perform(**args)
    process(**args)
  end

  def process(invoice:)
    subscription = Subscription.find_or_create_by(stripe_id: invoice.subscription)
    subscription.update(status: 'paid')
  end
end
