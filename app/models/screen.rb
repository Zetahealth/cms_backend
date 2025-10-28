class Screen < ApplicationRecord
    has_many :assignments, dependent: :destroy
    has_many :contents, through: :assignments
    before_validation :generate_slug, on: :create

    validates :name, presence: true
    validates :slug, uniqueness: true

    private

    def generate_slug
        self.slug ||= name.parameterize if name.present?
    end
end
