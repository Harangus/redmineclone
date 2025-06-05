class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project

  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :subject, :status, :user_id, :project_id, presence: true

  before_validation :set_default_status, on: :create

  STATUSES = ["New", "In Progress", "Waiting for client", "Done"]

  def set_default_status
    self.status ||= "New"
  end
end
