class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  after_create_commit -> {broadcast_append_to current_user_notifications_stream}
  after_update_commit :broadcast_remove_if_read

  def current_user_notifications_stream
    "notifications_for_user_#(user_id)"
  end

  def broadcast_remove_if_read
    if saved_change_to_read? && read
      broadcast_remove_to current_user_notifications_stream
    end
  end

  scope :unread, -> { where(read: false) }
end
