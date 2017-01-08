class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)
      binding.pry
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end

    WebhookProcessor.new(data).process
    head :ok
  end

end
