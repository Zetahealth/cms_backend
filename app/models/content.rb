# class Content < ApplicationRecord
#     has_many :assignments, dependent: :destroy
#     has_many_attached :files
#     validates :content_type, presence: true
# end
require 'rqrcode'

class Content < ApplicationRecord
  has_many_attached :files
  has_one_attached :qr_code
  has_many :assignments, dependent: :destroy
  validates :content_type, presence: true

  after_save :generate_qr_code_from_hyperlink, if: -> { hyperlink.present? && saved_change_to_hyperlink? }

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


end
