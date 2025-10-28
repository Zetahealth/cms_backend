class Api::V1::ContentsController < ApplicationController
    # before_action :authorize_request, except: [:index, :show]
    skip_before_action :authorize_request, only: [:index, :show, :create]


    include Rails.application.routes.url_helpers
    def index
    render json: Content.all.map {|c| content_serializer(c) }
    end

    def show
    c = Content.find(params[:id])
    render json: content_serializer(c)
    end

    def create
    c = Content.new(content_params)
    if c.save
        if params[:files].present?
        params[:files].each { |f| c.files.attach(f) }
        end
        render json: content_serializer(c), status: :created
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
    params.permit(:title, :content_type, :metadata)
    end

    def content_serializer(c)
    {
        id: c.id,
        title: c.title,
        content_type: c.content_type,
        files: c.files.map { |f| rails_blob_url(f, only_path: false) },
        created_at: c.created_at
    }
    end
end
