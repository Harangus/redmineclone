class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def mark_as_read
        @notification = current_user.notifications.find(params[:id])
        if @notification.update(read: true)
            # ok
        else
            # Log error messages if the update fails
            Rails.logger.error(@notification.errors.full_messages)
        end

        # Mark the notification as read, then remove it from the view via Turbo Stream
        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.remove(@notification)}
            format.html { redirect_to projects_path }
        end
    end
end
