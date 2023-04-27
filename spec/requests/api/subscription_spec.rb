# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Subscriptions', type: :request do
  describe 'POST Subscriptions' do
    let(:subscription_id) { 'foo-123' }
    let(:customer_id) { 'bar-234' }

    before do
      allow(Stripe::Event).to receive(:retrieve).and_return(event)
    end

    context 'customer.subscription.created' do
      let(:data_object) do
        double('object', id: subscription_id, customer: customer_id, current_period_start: Time.now.to_i,
                         current_period_end: Time.now + 30.days)
      end
      let(:event_data) { double('data', object: data_object) }
      let(:event) { double('Stripe::Event',  type: 'customer.subscription.created', data: event_data) }

      it 'triggers SubscriptionCreatedJob' do
        expect(SubscriptionCreatedJob).to receive(:perform_now).with(subscription: event.data.object)

        post api_subscriptions_path(id: subscription_id)
      end

      it 'returns a success response' do
        post api_subscriptions_path(id: subscription_id)

        expect(response.status).to eq(200)
        expect(response.body).to eq({ message: 'Event received' }.to_json)
      end
    end

    context 'invoice.payment_succeeded' do
      let(:data_object) { double('object', subscription: subscription_id) }
      let(:event_data) { double('data', object: data_object) }
      let(:event) { double('Stripe::Event', id: subscription_id, type: 'invoice.payment_succeeded', data: event_data) }

      it 'triggers InvoicePaymentSucceededJob' do
        expect(InvoicePaymentSucceededJob).to receive(:perform_now).with(invoice: event.data.object)

        post api_subscriptions_path(id: subscription_id)
      end

      it 'returns a success response' do
        post api_subscriptions_path(id: subscription_id)

        expect(response.status).to eq(200)
        expect(response.body).to eq({ message: 'Event received' }.to_json)
      end
    end
  end
end
