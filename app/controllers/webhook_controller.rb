class WebhookController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def click
    puts '1111'
    puts params.inspect
  end
end
