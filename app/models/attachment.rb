class Attachment < ApplicationRecord
  belongs_to :task
  has_one_attached :file

  validate :acceptable_file

  private

  def acceptable_file
    return unless file.attached?

    unless file.byte_size <= 10.megabytes
      errors.add(:file, "is too big, maximum is 10MB")
    end

    acceptable_types = ["image/png", "image/jpeg", "image/gif", "application/pdf", "application/msword", "application/zip", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"]
    unless acceptable_types.include?(file.content_type)
      errors.add(:file, "must be a png, jpg, gif, pdf, zip or doc/docx")
    end
  end
end
