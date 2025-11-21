class Api::V1::ScreenContainersController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show , :create, :assign_screen, :unassign_screen , :destroy , :update]

  def index
    containers = ScreenContainer.includes(:screens).all
    render json: containers.map { |c|
      {
        id: c.id,
        name: c.name,
        content_type: c.content_type,
        transition_effect: c.transition_effect,
        display_mode: c.display_mode,
        # background_url: c.background.attached? ? url_for(c.background) : nil,
        background_url: c.background.attached? ? Rails.application.routes.url_helpers.rails_blob_url(c.background, host: "https://backendafp.connectorcore.com") : nil,
        files: c.files.map { |f| url_for(f) },
        screens: c.screens.map { |s| { id: s.id, name: s.name, slug: s.slug, display_mode: s.display_mode } }
      }
    }
  end


  def show
      container = ScreenContainer.includes(:screens).find(params[:id])

      render json: {
        id: container.id,
        name: container.name,
        content_type: container.content_type,
        transition_effect: container.transition_effect,
        display_mode: container.display_mode,

        # ✅ Container images
        background_url: container.background.attached? ? Rails.application.routes.url_helpers.rails_blob_url(container.background, host: "https://backendafp.connectorcore.com") : nil,
        # files: container.files.map { |f| url_for(f) },
        files: container.files.map { |f|
          Rails.application.routes.url_helpers.rails_blob_url(
            f,
            host: "https://backendafp.connectorcore.com0"
          )
        },

        # ✅ Screens with images
        screens: container.screens.map { |s|
          {
            id: s.id,
            name: s.name,
            slug: s.slug,
            background_url: s.background.attached? ? Rails.application.routes.url_helpers.rails_blob_url(s.background, host: "https://backendafp.connectorcore.com") : nil,
            display_mode: s.display_mode,
            title: s.title,
            card_image_url: s.card_image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(s.card_image, host: "https://backendafp.connectorcore.com") : nil,
            # files: s.background.map { |f| url_for(f) }
          }
        }
      }
    end

  # def create
  #   container = ScreenContainer.new(name: params[:name])
  #   if container.save
  #     render json: container, status: :created
  #   else
  #     render json: { error: container.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # def create
  #   container = ScreenContainer.new(container_params.except(:files, :background))

  #   if params[:files].present?
  #     Array(params[:files]).each { |f| container.files.attach(f) }
  #   end

  #   if params[:background].present?
  #     container.background.attach(params[:background])
  #   end

  #   if container.save
  #     render json: container, status: :created
  #   else
  #     render json: { errors: container.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def create
    container = ScreenContainer.new(container_params.except(:files, :background))

    if params[:files].present?
      Array(params[:files]).each { |f| container.files.attach(f) }
    end

    if params[:background].present?
      container.background.attach(params[:background])
    end

    if container.save
      render json: {
        id: container.id,
        name: container.name,
        content_type: container.content_type,
        display_mode: container.display_mode,
        background_url: container.background.attached? ? url_for(container.background) : nil,
        files: container.files.map { |f| url_for(f) }
      }, status: :created
    else
      render json: { errors: container.errors.full_messages }, status: :unprocessable_entity
    end
  end





  def assign_screen
    container = ScreenContainer.find(params[:id])
    screen = Screen.find(params[:screen_id])
    container.screens << screen unless container.screens.include?(screen)
    render json: { message: "Screen assigned successfully" }
  end

  def unassign_screen
    container = ScreenContainer.find(params[:id])
    if params[:screen_id].present?
      ScreenBroadcaster.container_refresh(container)
    end

    screen = Screen.find(params[:screen_id])
    container.screens.delete(screen)
    render json: { message: "Screen unassigned successfully" }
  end

  def destroy
    ScreenContainer.find(params[:id]).destroy
    render json: { message: "Deleted" }
  end


    # UPDATE CONTAINER
  def update
    c = ScreenContainer.find(params[:id])

    # Update simple fields
    c.update(
      name: params[:name],
      content_type: params[:content_type],
      transition_effect: params[:transition_effect]
    )

    # -------------------------
    # REPLACE CARD IMAGE (ONE FILE ONLY)
    # -------------------------
    if params[:files].present?
      c.files.purge                   # remove all existing
      c.files.attach(params[:files])   # attach ONLY ONE file
    end

    # -------------------------
    # REPLACE BACKGROUND
    # -------------------------
    if params[:background].present?
      c.background.purge
      c.background.attach(params[:background])
    end

    render json: {
      id: c.id,
      name: c.name,
      content_type: c.content_type,
      display_mode: c.display_mode,
      background_url: c.background.attached? ? url_for(c.background) : nil,
      files: c.files.map { |f| url_for(f) },
      screens: c.screens.map { |s| { id: s.id, name: s.name } }
    }
  end



  private
  def container_params
    params.permit(:name, :content_type, :transition_effect, :background, :display_mode, files: [] )
  end

end
