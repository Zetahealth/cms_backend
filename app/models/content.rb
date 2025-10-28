class Content < ApplicationRecord
    has_many :assignments, dependent: :destroy
    has_many_attached :files
    validates :content_type, presence: true
end
