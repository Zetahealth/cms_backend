class Api::V1::ContentsController < ApplicationController
    # before_action :authorize_request, except: [:index, :show]
    skip_before_action :authorize_request, only: [:index, :show, :create , :destroy , :update]


    include Rails.application.routes.url_helpers
    def index
    render json: Content.all.map {|c| content_serializer(c) }
    end

    def show
    c = Content.find(params[:id])
    render json: content_serializer(c)
    end

    # def create
    #     c = Content.new(content_params)

    #     if c.save
    #         # Attach uploaded files if present
    #         if params[:files].present?
    #         params[:files].each { |f| c.files.attach(f) }
    #         end

    #         # ✅ Generate QR code automatically if hyperlink exists
    #         if c.hyperlink.present?
    #         qrcode = RQRCode::QRCode.new(c.hyperlink)
    #         png = qrcode.as_png(size: 200)
    #         c.qr_code.attach(
    #             io: StringIO.new(png.to_s),
    #             filename: "qr_code.png",
    #             content_type: "image/png"
    #         )
    #         end

    #         render json: content_serializer(c), status: :created
    #     else
    #         render json: { errors: c.errors.full_messages }, status: :unprocessable_entity
    #     end
    # end


    def create
    c = Content.new(content_params)

    if c.save

        # Handle multiple attached files
        if params[:files].present?
        if params[:files].is_a?(Array)
            params[:files].each { |f| c.files.attach(f) }
        else
            c.files.attach(params[:files])
        end
        end

        # Optional Logo Upload
        if params[:logo].present?
        c.logo.attach(params[:logo])
        end

        if params[:background].present?
            c.background.attach(params[:background])
        end

        

        # Generate QR Code only if hyperlink exists
        if c.hyperlink.present?
        qrcode = RQRCode::QRCode.new(c.hyperlink)
        png = qrcode.as_png(size: 200)

        c.qr_code.attach(
            io: StringIO.new(png.to_s),
            filename: "qr_code.png",
            content_type: "image/png"
        )
        end

        render json: content_serializer(c), status: :created
    else
        render json: { errors: c.errors.full_messages }, status: :unprocessable_entity
    end
    end



    def update
        c = Content.find(params[:id])

        if c.update(content_params)
        # ✅ Replace files if new ones are uploaded
        if params[:files].present?
            c.files.purge # remove old files
            if params[:files].is_a?(Array)
            params[:files].each { |f| c.files.attach(f) }
            else
            c.files.attach(params[:files])
            end
        end

        # ✅ Replace logo if a new one is uploaded
        if params[:logo].present?
        c.logo.purge if c.logo.attached?
        c.logo.attach(params[:logo])
        end

        if params[:background].present?
            c.background.purge if c.background.attached?
            c.background.attach(params[:background])
        end





        # ✅ Regenerate QR code if hyperlink updated
        if params[:hyperlink].present?
            c.qr_code.purge if c.qr_code.attached?
            attach_qr_code(c)
        end

        render json: content_serializer(c), status: :ok
        else
        render json: { errors: c.errors.full_messages }, status: :unprocessable_entity
        end
    end



    def destroy
    c = Content.find(params[:id])
    c.destroy
    head :no_content
    end

    private
    def content_params
    params.permit(:title, :content_type, :metadata ,:content ,:position ,:hyperlink , :transition_effect,:logo,:background ,:dob ,:display_mode , files: [])
    end

    def content_serializer(c)
    {
        id: c.id,
        title: c.title,
        content_type: c.content_type,
        content: c.content,
        position: c.position,
        hyperlink: c.hyperlink,
        transition_effect: c.transition_effect,
        files: c.files.map { |f| rails_blob_url(f, only_path: false) },
        # background_url: c.background.map { |f| rails_blob_url(f, only_path: false) },
        dob: c.dob,
        display_mode: c.display_mode,
        created_at: c.created_at
    }
    end

    def attach_qr_code(content)
        return unless content.hyperlink.present?

        qrcode = RQRCode::QRCode.new(content.hyperlink)
        png = qrcode.as_png(size: 200)
        content.qr_code.attach(
        io: StringIO.new(png.to_s),
        filename: "qr_code.png",
        content_type: "image/png"
        )
    end


end
