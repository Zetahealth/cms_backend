# class Api::V1::SubContentsController < ApplicationController
# end
class Api::V1::SubContentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :create]
  before_action :set_sub_content, only: [:show, :update, :destroy]

  def index
    sub_contents = params[:content_id] ?
      SubContent.where(content_id: params[:content_id]) :
      SubContent.all

    render json: sub_contents.map { |sc| sc_data(sc) }
  end

  def show
    render json: sc_data(@sub_content)
  end

  # def create
  #   sc = SubContent.new(sub_content_params)

  #   sc.main_image.attach(params[:main_image]) if params[:main_image].present?
  #   sc.sub_image.attach(params[:sub_image]) if params[:sub_image].present?
  #   sc.sub_image2.attach(params[:sub_image2]) if params[:sub_image2].present?

  #   sc.qr_code.attach(params[:qr_code]) if params[:qr_code].present?

  #   if params[:gallery_images].present?
  #     params[:gallery_images].each { |img| sc.gallery_images.attach(img) }
  #   end

  #   sub.asf_data = JSON.parse(params[:asf_data]) if params[:asf_data]

  #   params[:asf_group_images]&.each do |_k, img|
  #     sub.asf_group_images.attach(img)
  #   end

  #   params[:asf_item_images]&.each do |_k, group|
  #     group.each do |_i, img|
  #       sub.asf_item_images.attach(img)
  #     end
  #   end





  #   if sc.save
  #     render json: sc_data(sc), status: :created
  #   else
  #     render json: { error: sc.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def create
    sc = SubContent.new(sub_content_params)

    # Single attachments
    sc.main_image.attach(params[:main_image]) if params[:main_image].present?
    sc.sub_image.attach(params[:sub_image]) if params[:sub_image].present?
    sc.sub_image2.attach(params[:sub_image2]) if params[:sub_image2].present?
    sc.qr_code.attach(params[:qr_code]) if params[:qr_code].present?

    # Gallery images
    if params[:gallery_images].present?
      params[:gallery_images].each do |img|
        sc.gallery_images.attach(img)
      end
    end

    # ASF JSON data
    if params[:asf_data].present?
      sc.asf_data = JSON.parse(params[:asf_data])
    else
      sc.asf_data = {}
    end

    # ASF group images
    params[:asf_group_images]&.each do |_index, img|
      sc.asf_group_images.attach(img)
    end

    # ASF item images
    params[:asf_item_images]&.each do |_gIndex, items|
      items.each do |_iIndex, img|
        sc.asf_item_images.attach(img)
      end
    end

    if sc.save
      render json: sc_data(sc), status: :created
    else
      render json: { error: sc.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    @sub_content.update(sub_content_params)

    @sub_content.main_image.attach(params[:main_image]) if params[:main_image]
    @sub_content.qr_code.attach(params[:qr_code]) if params[:qr_code]
    @sub_content.sub_image.attach(params[:sub_image]) if params[:sub_image]
    @sub_content.sub_image2.attach(params[:sub_image2]) if params[:sub_image2]

    if params[:gallery_images]
      @sub_content.gallery_images.purge
      params[:gallery_images].each { |img| @sub_content.gallery_images.attach(img) }
    end

    render json: sc_data(@sub_content)
  end

  def destroy
    @sub_content.destroy
    head :no_content
  end

  private

  def set_sub_content
    @sub_content = SubContent.find(params[:id])
  end

  def sub_content_params
    params.permit(:title, :content_id, :description, :metadata , :individual_contents)
  end

  def sc_data(sc)
    {
      id: sc.id,
      title: sc.title,
      description: sc.description,
      metadata: sc.metadata,
      content_id: sc.content_id,
      main_image: sc.main_image.attached? ? url_for(sc.main_image) : nil,
      gallery_images: sc.gallery_images.map { |g| url_for(g) },
      qr_code: sc.qr_code.attached? ? url_for(sc.qr_code) : nil
    }
  end
end
