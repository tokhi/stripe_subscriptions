# frozen_string_literal: true

module Api
  class SubscriptionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      event = Stripe::Event.retrieve(subscription_params[:id])
      case event.type
      when 'customer.subscription.created'
        SubscriptionCreatedJob.perform_now(subscription: event.data.object)

      when 'invoice.payment_succeeded'
        InvoicePaymentSucceededJob.perform_now(invoice: event.data.object)
      end
      render json: { message: 'Event received' }
    end

    def subscription_params
      params.permit(:id)
    end
  end
end
