# class Content < ApplicationRecord
#     has_many :assignments, dependent: :destroy
#     has_many_attached :files
#     validates :content_type, presence: true
# end
require 'rqrcode'

class Content < ApplicationRecord
  has_many_attached :files
  has_one_attached :qr_code
  has_one_attached :logo
  has_one_attached :background
  
  has_many :assignments, dependent: :destroy
  validates :content_type, presence: true

  after_save :generate_qr_code_from_hyperlink, if: -> { hyperlink.present? && saved_change_to_hyperlink? }

  after_create :update_live_screen
  after_update :update_live_screen
  after_destroy :update_live_screen
  has_many :sub_contents, dependent: :destroy

  private

    def generate_qr_code_from_hyperlink
        qrcode = RQRCode::QRCode.new(hyperlink)
        png = qrcode.as_png(size: 200)
        qr_code.attach(
        io: StringIO.new(png.to_s),
        filename: "qr_code.png",
        content_type: "image/png"
        )
    end
    def qr_code_url
        qr_code.attached? ? Rails.application.routes.url_helpers.url_for(qr_code) : nil
    end

    def content_serializer(c)
        {
            id: c.id,
            title: c.title,
            content: c.content,
            content_type: c.content_type,
            position: c.position,
            hyperlink: c.hyperlink,
            files: c.files.map { |f| Rails.application.routes.url_helpers.url_for(f) },
            qr_code_url: c.qr_code.attached? ? Rails.application.routes.url_helpers.url_for(c.qr_code) : nil
        }
    end

    def update_live_screen
        puts "Contant created--------------------------: #{self.id}"
        Assignment.where( content_id: self.id ).each do |assignment|
            puts "Assignment Screen ID--------------------------: #{assignment.screen_id}"
            screen = assignment.screen_id 
            if screen.present?
                screen = Screen.find(screen)
                ScreenBroadcaster.refresh(screen) 
            end
        end
     
    end


end
