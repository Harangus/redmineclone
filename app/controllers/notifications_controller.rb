class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def mark_as_read
        @notification = current_user.notifications.find(params[:id])
        if @notification.update(read: true)
            # ok
        else
            Rails.logger.error(@notification.errors.full_messages)
        end

        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.remove(@notification)}
            format.html { redirect_to projects_path }
        end
    end
end
