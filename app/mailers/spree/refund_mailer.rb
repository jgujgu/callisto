module Spree
  class RefundMailer < BaseMailer
    def notify_store(store_email, amount, refund_id)
      @amount = (amount.to_money/100).to_s
      @refund_id = refund_id
      subject = "Flea $#{@amount} Refund"
      mail(to: store_email, from: ENV["EMAIL"], subject: subject)
    end
  end
end
