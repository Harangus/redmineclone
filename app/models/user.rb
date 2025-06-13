class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :tasks, dependent: :nullify
  has_one_attached :avatar

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :avatar, content_type: {
        in: ['image/png', 'image/jpeg', 'image/gif'],
        message: 'Allowed formats are: PNG, JPG, JPEG, GIF'
    },
        size: { less_than: 5.megabytes, message: 'Image is too big, max 5MB' }

  def to_s
    "#{first_name} #{last_name}"
  end
end
