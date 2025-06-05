class Project < ApplicationRecord
    has_many :tasks, dependent: :restrict_with_error

    validates :name, presence: true

    def to_s
        name
    end
end
