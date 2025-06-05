class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_many_attached :attachments

  validates :subject, :status, :user_id, :project_id, presence: true

  before_validation :set_default_status, on: :create

  def set_default_status
    self.status ||= "New"
  end
end
