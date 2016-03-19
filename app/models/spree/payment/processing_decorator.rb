Spree::Payment::Processing.class_eval do
  private
  def handle_response(response, success_state, failure_state)
    record_response(response)

    if response.success?
      self.response_code = response.params["stripe_charge_id"]
      unless response.authorization.nil?
        self.response_code = response.authorization
        self.avs_response = response.avs_result['code']

        if response.cvv_result
          self.cvv_response_code = response.cvv_result['code']
          self.cvv_response_message = response.cvv_result['message']
        end
      end
      self.send("#{success_state}!")
    else
      self.send(failure_state)
      gateway_error(response)
    end
  end
end
