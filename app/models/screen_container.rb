class ScreenContainer < ApplicationRecord
	has_many :screen_container_assignments, dependent: :destroy
  	has_many :screens, through: :screen_container_assignments
	has_many_attached :files
	has_one_attached :background
	after_create :update_live_screen
    after_update :update_live_screen

	private
	def update_live_screen
		puts "Screen Container created--------------------------: #{self.id}"

		ScreenBroadcaster.container_refresh(self) if self.present?

	end

end
