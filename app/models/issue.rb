class Issue < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true

  enum :status, { open: "open", in_progress: "in_progress", resolved: "resolved", closed: "closed" }
  enum :priority, { low: "low", medium: "medium", high: "high", critical: "critical" }

  before_validation do
    self.status ||= :open
    self.priority ||= :low
  end

  validates :title, :description, :status, :priority, presence: true
end
