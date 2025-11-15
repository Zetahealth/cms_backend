class ScreenContainer < ApplicationRecord
	has_many :screen_container_assignments, dependent: :destroy
  	has_many :screens, through: :screen_container_assignments
	has_many_attached :files
	has_one_attached :background

end
