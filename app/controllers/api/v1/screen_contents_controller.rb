# class Api::V1::ScreenContentsController < ApplicationController
#     skip_before_action :authorize_request, only: [:show]

#     def show
#         screen = Screen.find(params[:screen_id])
#         assignments = screen.assignments.includes(:content).order(:position)
#         active = assignments.map do |a|
#             c = a.content
#             {
#             id: c.id,
#             title: c.title,
#             content_type: c.content_type,
#             files: c.files.map { |f| Rails.application.routes.url_helpers.rails_blob_url(f, host: request.base_url) }
#             }
#         end
#         render json: active
#     end
# end

# app/controllers/api/v1/screen_contents_controller.rb
# class Api::V1::ScreenContentsController < ApplicationController
#   skip_before_action :authorize_request, only: [:show]

#   def show
#     screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])

#     assignments = screen.assignments.includes(:content).order(:position)
    
#     container_screen_ids = Screen.joins(:screen_containers)
#                                  .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
#                                  .pluck(:id)
#                                  .uniq



#     background_url = screen.background.attached? ? 
#       Rails.application.routes.url_helpers.rails_blob_url(screen.background, host: request.base_url) : nil

#     contents = assignments.map do |a|
#       c = a.content
#       {
#         id: c.id,
#         title: c.title,
#         content_type: c.content_type,
#         screens_ids: [],
#         content: c.content,
#         files: c.files.map { |f| Rails.application.routes.url_helpers.rails_blob_url(f, host: request.base_url) }
#       }
#     end

#     render json: {
#       background_url: background_url,
#       contents: contents
#     }
#   end
# end
# class Api::V1::ScreenContentsController < ApplicationController
#   skip_before_action :authorize_request, only: [:show]

#   def show
#     screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])

#     # Find all other screens linked to the same containers as this screen
#     container_screen_ids = Screen.joins(:screen_containers)
#                                  .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
#                                  .pluck(:id)
#                                  .uniq

#     assignments = screen.assignments.includes(:content).order(:position)

#     background_url = screen.background.attached? ? 
#       Rails.application.routes.url_helpers.rails_blob_url(screen.background, host: request.base_url) : nil

#     contents = assignments.map do |a|
#       c = a.content
#       {
#         id: c.id,
#         title: c.title,
#         content_type: c.content_type,
#         screens_ids: container_screen_ids, # 👈 all screen IDs related to same container
#         content: c.content,
#         files: c.files.map { |f| Rails.application.routes.url_helpers.rails_blob_url(f, host: request.base_url) }
#       }
#     end

#     render json: {
#       background_url: background_url,
#       contents: contents
#     }
#   end
# end
# class Api::V1::ScreenContentsController < ApplicationController
#   skip_before_action :authorize_request, only: [:show]

#   def show
#     screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])

#     # Find all screen IDs in same container(s)
#     container_screen_ids = Screen.joins(:screen_containers)
#                                  .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
#                                  .order(:id)
#                                  .pluck(:id)
#                                  .uniq

#     current_index = container_screen_ids.index(screen.id)
#     prev_screen_id = current_index && current_index > 0 ? container_screen_ids[current_index - 1] : nil
#     next_screen_id = current_index && current_index < container_screen_ids.length - 1 ? container_screen_ids[current_index + 1] : nil

#     assignments = screen.assignments.includes(:content).order(:position)

#     background_url = screen.background.attached? ? 
#       Rails.application.routes.url_helpers.rails_blob_url(screen.background, host: request.base_url) : nil

#     contents = assignments.map do |a|
#       c = a.content
#       {
#         id: c.id,
#         title: c.title,
#         content_type: c.content_type,
#         screens_ids: container_screen_ids, # 👈 all screens for container
#         current_screen_id: screen.id,
#         next_screen_id: next_screen_id,
#         prev_screen_id: prev_screen_id,
#         position: c.position,
#         content: c.content,
#         files: c.files.map { |f| Rails.application.routes.url_helpers.rails_blob_url(f, host: request.base_url) }
#       }
#     end

#     render json: {
#       background_url: background_url,
#       contents: contents
#     }
#   end
# end

# class Api::V1::ScreenContentsController < ApplicationController
#   skip_before_action :authorize_request, only: [:show]

#   def show
#     screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])

#     # Find all screen IDs in same container(s)
#     container_screen_ids = Screen.joins(:screen_containers)
#                                  .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
#                                  .order(:id)
#                                  .pluck(:id)
#                                  .uniq

#     current_index = container_screen_ids.index(screen.id)
#     prev_screen_id = current_index && current_index > 0 ? container_screen_ids[current_index - 1] : nil
#     next_screen_id = current_index && current_index < container_screen_ids.length - 1 ? container_screen_ids[current_index + 1] : nil

#     assignments = screen.assignments.includes(:content).order(:position)

#     background_url = screen.background.attached? ? 
#       Rails.application.routes.url_helpers.rails_blob_url(screen.background, host: request.base_url) : nil

#     contents = assignments.map do |a|
#       c = a.content
#       {
#         id: c.id,
#         title: c.title,
#         content_type: c.content_type,
#         screens_ids: container_screen_ids,
#         current_screen_id: screen.id,
#         next_screen_id: next_screen_id,
#         prev_screen_id: prev_screen_id,
#         position: c.position,
#         content: c.content,
#         hyperlink: c.hyperlink, # ✅ Include hyperlink
#         qr_code_url: c.qr_code.attached? ? Rails.application.routes.url_helpers.rails_blob_url(c.qr_code, host: request.base_url) : nil, # ✅ Add QR URL
#         files: c.files.map { |f| Rails.application.routes.url_helpers.rails_blob_url(f, host: request.base_url) }
#       }
#     end

#     render json: {
#       background_url: background_url,
#       contents: contents
#     }
#   end
# end

class Api::V1::ScreenContentsController < ApplicationController
  skip_before_action :authorize_request, only: [:show]

  def show
    screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])

    # Find all screen IDs in same container(s)
    container_screen_ids = Screen.joins(:screen_containers)
                                 .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
                                 .order(:id)
                                 .pluck(:id)
                                 .uniq

    current_index = container_screen_ids.index(screen.id)
    prev_screen_id = current_index && current_index > 0 ? container_screen_ids[current_index - 1] : nil
    next_screen_id = current_index && current_index < container_screen_ids.length - 1 ? container_screen_ids[current_index + 1] : nil

    assignments = screen.assignments.includes(:content).order(:position)

    background_url = screen.background.attached? ? 
      Rails.application.routes.url_helpers.rails_blob_url(screen.background, host: "https://backendafp.connectorcore.com") : nil

    contents = assignments.map do |a|
      c = a.content
      {
        id: c.id,
        title: c.title,
        content_type: c.content_type,
        screens_ids: container_screen_ids,
        current_screen_id: screen.id,
        next_screen_id: next_screen_id,
        prev_screen_id: prev_screen_id,
        position: c.position,
        content: c.content,
        hyperlink: c.hyperlink,
        transition_effect: c.transition_effect,
        qr_code_url: c.qr_code.attached? ?
          Rails.application.routes.url_helpers.rails_blob_url(c.qr_code, host: "https://backendafp.connectorcore.com") : nil,
        files: c.files.map { |f|
          Rails.application.routes.url_helpers.rails_blob_url(f, host: "https://backendafp.connectorcore.com")
        }
      }
    end

    render json: {
      background_url: background_url,
      contents: contents,
      display_mode: screen.display_mode,
      id: screen.id
    }
  end
end
