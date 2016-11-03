class NotificationMailgun
  def initialize(notification)
    @notification = notification
  end

  def send_email
    RestClient::Request.execute( method: :post, url: "https://api:#{mg_api_key}@api.mailgun.net/v3/#{mailgun_domain}/messages", payload: {from: ENV['sender_email'], to: @notification.email, subject: @notification.subject, text: @notification.text, 'o:campaign' => @notification.campaign_id, multipart: true} )
  end

  def fetch_emails
    RestClient.get("https://api:#{mg_api_key}@api.mailgun.net/v3/#{mailgun_domain}/events", {params: {limit: 25, recipient: @notification.email}})
  end

  def check_in_suppression_list
    in_bounce_list = false
    begin
      response = RestClient.get "https://api:#{mg_api_key}@api.mailgun.net/v3/#{mailgun_domain}/bounces/#{@notification.email}"
      if JSON.parse(response)["code"].to_i == 550
        in_bounce_list = true
      end
    rescue Exception => e
      if e.response.code == 404
        in_bounce_list = false
      end
    end
    in_bounce_list
  end

  private
    def mailgun_domain
      ENV['mailgun_domain']
    end

    def mg_api_key
      ENV['mailgun_api_key']
    end
end
