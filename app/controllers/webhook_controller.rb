class WebhookController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:click]

  def index
    @webhooks = Webhook.all
  end

  def click
    webhook = Webhook.create(event_type: webhook_params[:event], data: webhook_params)
  end

  private
  def webhook_params
    params.permit!.to_h
  end
end
