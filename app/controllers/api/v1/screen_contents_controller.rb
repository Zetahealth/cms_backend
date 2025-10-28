class Api::V1::ScreenContentsController < ApplicationController
    skip_before_action :authorize_request, only: [:show]

    def show
        screen = Screen.find(params[:screen_id])
        assignments = screen.assignments.includes(:content).order(:position)
        active = assignments.map do |a|
            c = a.content
            {
            id: c.id,
            title: c.title,
            content_type: c.content_type,
            files: c.files.map { |f| Rails.application.routes.url_helpers.rails_blob_url(f, host: request.base_url) }
            }
        end
        render json: active
    end
end

