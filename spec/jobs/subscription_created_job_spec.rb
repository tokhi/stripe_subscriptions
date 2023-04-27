# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionCreatedJob, type: :job do
  let(:subscription_id) { '87d7y2c' }
  let(:customer_id) { 'u87xdf' }

  let(:subscription) do
    double('subscription', id: subscription_id, customer: customer_id, current_period_start: Time.now,
                           current_period_end: Time.now + 30.days)
  end

  describe '#perform' do
    it 'calls #process with the correct arguments' do
      expect_any_instance_of(SubscriptionCreatedJob).to receive(:process).with(subscription:)

      SubscriptionCreatedJob.perform_now(subscription:)
    end
  end

  describe '#process' do
    it 'creates a new subscription record with the correct attributes' do
      expect do
        SubscriptionCreatedJob.new.process(subscription:)
      end.to change(Subscription, :count).by(1)

      last_sub = Subscription.last

      expect(last_sub.customer_id).to eq(customer_id)
      expect(last_sub.status).to eq('unpaid')
      expect(last_sub.start_date).to eq(subscription.current_period_start)
      expect(last_sub.end_date).to eq(subscription.current_period_end)
    end
  end
end
