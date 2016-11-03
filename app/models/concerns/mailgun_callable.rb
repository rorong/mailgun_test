module MailgunCallable
  extend ActiveSupport::Concern

  def send_email
    service.send_email
  end

  def fetch_emails
    service.fetch_emails
  end

  def check_in_suppression_list
    service.check_in_suppression_list
  end

  private
    def service
      NotificationMailgun.new(self)
    end
end
