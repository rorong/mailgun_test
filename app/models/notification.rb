class Notification < ApplicationRecord
  attr_accessor :subject, :text, :campaign_id

  MAILER_FIELDS = %w( subject text campaign_id )

  include MailgunCallable

  # validations
  validates_presence_of :email
  validate :check_suppression

  def send_email_notification params={}
    params.slice(*MAILER_FIELDS).each{ |k, v| self.send("#{k}=", v) }
    send_email
  end

  def check_suppression
    if check_in_suppression_list
      self.errors.add(:base, "Email found in bounce email list.")
    end
  end
end
