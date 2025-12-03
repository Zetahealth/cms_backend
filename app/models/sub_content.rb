class SubContent < ApplicationRecord
    belongs_to :content
    has_one_attached :main_image
    has_many_attached :gallery_images
    has_one_attached :qr_code
    has_one_attached :sub_image
end
