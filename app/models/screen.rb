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

    after_create :update_live_screen
    after_update :update_live_screen
  
    
    private

    def generate_slug
        self.slug ||= name.parameterize if name.present?
    end

    def update_live_screen
        # puts "Screen created--------------------------: #{self.slug}"
        # puts "Container ID--------------------------: #{self.screen_containers.pluck(:id)}"
        ScreenBroadcaster.refresh(self)
        if self.screen_containers.any?
            self.screen_containers.each do |container|
                # puts "Assigned Container ID--------------------------: #{container.id}"
                ScreenBroadcaster.container_refresh(container)
            end
        end

    end
end
