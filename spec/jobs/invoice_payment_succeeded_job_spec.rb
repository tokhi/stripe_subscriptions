# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicePaymentSucceededJob, type: :job do
  let(:subscription) { FactoryBot.create(:subscription) }

  let(:invoice) do
    double('invoice', subscription: subscription.stripe_id)
  end

  describe '#perform' do
    it 'executes the job' do
      expect_any_instance_of(InvoicePaymentSucceededJob).to receive(:process).with(invoice:)

      InvoicePaymentSucceededJob.perform_now(invoice:)
    end
  end

  describe '#process' do
    it 'finds/generates a subscription with paid status' do
      expect do
        InvoicePaymentSucceededJob.new.process(invoice:)
        subscription.reload
      end.to change(subscription, :status).to('paid')
    end
  end
end
