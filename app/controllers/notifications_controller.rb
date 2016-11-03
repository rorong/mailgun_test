class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.all
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    @emails = JSON.parse(@notification.fetch_emails)
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # POST /notifications
  # POST /notifications.json
  def create
    begin
      @notification = Notification.find_or_initialize_by(email: notification_params['email'])
      @notification.send_email_notification(notification_params) if @notification.valid?

      respond_to do |format|
        if @notification.save
          format.html { redirect_to @notification, notice: 'Mail has been sent successfully.' }
          format.json { render :show, status: :created, location: @notification }
        else
          format.html { render :new }
          format.json { render json: @notification.errors, status: :unprocessable_entity }
        end
      end
    rescue Exception => e
      @notification.errors.add(:base, JSON.parse(e.response)['message'])
      respond_to do |format|
        format.html { render :new }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:email, :subject, :text, :campaign_id)
    end
end
