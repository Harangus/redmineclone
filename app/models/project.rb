class Project < ApplicationRecord
    has_many :tasks, dependent: :restrict_with_error

    validates :name, presence: true

    def to_s
        name
    end

    def self.ransackable_attributes(auth_object = nil)
        %w[name description created_at tasks_count]
    end
end
