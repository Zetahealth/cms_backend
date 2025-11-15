class Screen < ApplicationRecord
    has_many :assignments, dependent: :destroy
    has_many :contents, through: :assignments
    before_validation :generate_slug, on: :create

    validates :name, presence: true
    validates :slug, uniqueness: true
    has_one_attached :background

    has_many :screen_container_assignments
    has_many :screen_containers, through: :screen_container_assignments
    has_one_attached :card_image

    
    private

    def generate_slug
        self.slug ||= name.parameterize if name.present?
    end
end
