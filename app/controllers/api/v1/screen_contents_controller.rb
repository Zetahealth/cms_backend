# class Api::V1::ScreenContentsController < ApplicationController
#   skip_before_action :authorize_request, only: [:show]

#   def show
#     screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])
#     container_ids = screen.screen_containers.pluck(:id)
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
#       Rails.application.routes.url_helpers.rails_blob_url(screen.background, host: "https://backendafp.connectorcore.com") : nil

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
#         hyperlink: c.hyperlink,
        
        
#         transition_effect: c.transition_effect,
#         qr_code_url: c.qr_code.attached? ?
#           Rails.application.routes.url_helpers.rails_blob_url(c.qr_code, host: "https://backendafp.connectorcore.com") : nil,
#         files: c.files.map { |f|
#           Rails.application.routes.url_helpers.rails_blob_url(f, host: "https://backendafp.connectorcore.com")
#         },
#         logo: c.logo.attached? ?
#           Rails.application.routes.url_helpers.rails_blob_url(c.logo, host: "https://backendafp.connectorcore.com") : nil,

#       }
#     end

#     render json: {
#       background_url: background_url,
#       contents: contents,
#       container_ids: container_ids,
#       display_mode: screen.display_mode,
#       screen_name: screen.title,
#       id: screen.id
#     }
#   end
# end
# class Api::V1::ScreenContentsController < ApplicationController
#   skip_before_action :authorize_request, only: [:show]

#   def show
#     screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])

#     container_ids = screen.screen_containers.pluck(:id)

#     # Screens inside same container group
#     container_screen_ids = Screen.joins(:screen_containers)
#                                  .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
#                                  .order(:id)
#                                  .pluck(:id)
#                                  .uniq

#     current_index = container_screen_ids.index(screen.id)
#     prev_screen_id = current_index && current_index > 0 ? container_screen_ids[current_index - 1] : nil
#     next_screen_id = current_index && current_index < container_screen_ids.length - 1 ? container_screen_ids[current_index + 1] : nil

#     assignments = screen.assignments.includes(:content).order(:position)

#     # Background
#     background_url = screen.background.attached? ?
#       Rails.application.routes.url_helpers.rails_blob_url(
#         screen.background, host: "https://backendafp.connectorcore.com"
#       ) : nil

#     contents = assignments.map do |a|
#       c = a.content

#       # 🔥 Fetch SubContents of this specific content
#       sub_contents = SubContent.where(content_id: c.id).map do |sub|
#         {
#           id: sub.id,
#           description: sub.description,
#           main_image: sub.main_image.attached? ?
#             Rails.application.routes.url_helpers.rails_blob_url(
#               sub.main_image, host: "https://backendafp.connectorcore.com"
#             ) : nil,

#           gallery_images: sub.gallery_images.map {
#             |img| Rails.application.routes.url_helpers.rails_blob_url(img, host: "https://backendafp.connectorcore.com")
#           },

#         }
#       end

#       # 🔥 Main Content JSON
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
#         hyperlink: c.hyperlink,
#         transition_effect: c.transition_effect,

#         qr_code_url: c.qr_code.attached? ?
#           Rails.application.routes.url_helpers.rails_blob_url(
#             c.qr_code, host: "https://backendafp.connectorcore.com"
#           ) : nil,

#         files: c.files.map {
#           |f| Rails.application.routes.url_helpers.rails_blob_url(
#             f, host: "https://backendafp.connectorcore.com"
#           )
#         },

#         logo: c.logo.attached? ?
#           Rails.application.routes.url_helpers.rails_blob_url(
#             c.logo, host: "https://backendafp.connectorcore.com"
#           ) : nil,

#         # 🔥 ADD SUBCONTENTS HERE
#         sub_contents: sub_contents

#       }
#     end

#     render json: {
#       background_url: background_url,
#       contents: contents,
#       container_ids: container_ids,
#       display_mode: screen.display_mode,
#       screen_name: screen.title,
#       id: screen.id
#     }
#   end
# end
class Api::V1::ScreenContentsController < ApplicationController
  skip_before_action :authorize_request, only: [:show]

  def show
    screen = Screen.find_by(slug: params[:slug]) || Screen.find(params[:screen_id])

    container_ids = screen.screen_containers.pluck(:id)

    
    if container_ids.blank?
      container_ids = screen.subscreen_containers.pluck(:id)

      container_files = screen.subscreen_containers.flat_map do |container|
        container.files.map do |f|
          Rails.application.routes.url_helpers.rails_blob_url(
            f,
            host: "https://backendafp.connectorcore.com"
          )
        end
      end
      container_screen_ids = Screen.joins(:subscreen_containers)
                                 .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
                                 .order(:id)
                                 .pluck(:id)
                                 .uniq
    else
      container_files = screen.screen_containers.flat_map do |container|
        container.files.map do |f|
          Rails.application.routes.url_helpers.rails_blob_url(
            f,
            host: "https://backendafp.connectorcore.com"
          )
        end
      end
      container_screen_ids = Screen.joins(:screen_containers)
                                 .where(screen_containers: { id: screen.screen_containers.pluck(:id) })
                                 .order(:id)
                                 .pluck(:id)
                                 .uniq
    end

    puts container_ids.inspect
 

    # Fetch container files (ONLY files)

    current_index = container_screen_ids.index(screen.id)
    prev_screen_id = current_index && current_index > 0 ? container_screen_ids[current_index - 1] : nil
    next_screen_id = current_index && current_index < container_screen_ids.length - 1 ? container_screen_ids[current_index + 1] : nil

    assignments = screen.assignments.includes(:content).order(:position)

    background_url = screen.background.attached? ?
      Rails.application.routes.url_helpers.rails_blob_url(screen.background, host: "https://backendafp.connectorcore.com") : nil

    contents = assignments.map do |a|
      c = a.content

      # Fetch SubContents
      sub_contents_records = SubContent.where(content_id: c.id)

      sub_contents = sub_contents_records.map do |sub|
        {
          id: sub.id,
          description: sub.description,
          title: sub.title,
          individual_contents: sub.individual_contents,
          sub_image: sub.sub_image.attached? ?
            Rails.application.routes.url_helpers.rails_blob_url(sub.sub_image, host: "https://backendafp.connectorcore.com")
            : nil,
          sub_image2: sub.sub_image2.attached? ?
            Rails.application.routes.url_helpers.rails_blob_url(sub.sub_image2, host: "https://backendafp.connectorcore.com")
            : nil,
          
          main_image: sub.main_image.attached? ?
            Rails.application.routes.url_helpers.rails_blob_url(sub.main_image, host: "https://backendafp.connectorcore.com")
            : nil,

          gallery_images: sub.gallery_images.map { |img|
            Rails.application.routes.url_helpers.rails_blob_url(img, host: "https://backendafp.connectorcore.com")
          }
        }
      end

      {
        id: c.id,
        title: c.title,
        content_type: c.content_type,
        screens_ids: container_screen_ids,
        current_screen_id: screen.id,
        next_screen_id: next_screen_id,
        prev_screen_id: prev_screen_id,
        dob:  c.dob,
        view_mode: c.view_mode,
        position: c.position,
        content: c.content,
        hyperlink: c.hyperlink,
        transition_effect: c.transition_effect,

        background_url: c.background.attached? ?
          Rails.application.routes.url_helpers.rails_blob_url(c.background, host: "https://backendafp.connectorcore.com")
          : nil,

        qr_code_url: c.qr_code.attached? ?
          Rails.application.routes.url_helpers.rails_blob_url(c.qr_code, host: "https://backendafp.connectorcore.com")
          : nil,

        files: c.files.map { |f|
          Rails.application.routes.url_helpers.rails_blob_url(f, host: "https://backendafp.connectorcore.com")
        },

        logo: c.logo.attached? ?
          Rails.application.routes.url_helpers.rails_blob_url(c.logo, host: "https://backendafp.connectorcore.com")
          : nil,

        # Include sub contents
        sub_contents: sub_contents,

        # 🚀 FLAG: true if subcontents exist
        has_subcontent: sub_contents_records.any?
      }
    end

    render json: {
      background_url: background_url,
      contents: contents,
      container_ids: container_ids,
      container_files: container_files, 
      display_mode: screen.display_mode,
      screen_name: screen.name,
      id: screen.id
    }
  end
end
