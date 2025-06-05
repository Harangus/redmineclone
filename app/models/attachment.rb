class Attachment < ApplicationRecord
  belongs_to :task
  has_one_attached :file
end
