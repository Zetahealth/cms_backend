class Api::V1::AssignmentsController < ApplicationController
    skip_before_action :authorize_request

    def index
        if params[:screen_id]
            assignments = Assignment.where(screen_id: params[:screen_id]).includes(:content)
            render json: assignments.as_json(include: :content)
        else
            render json: Assignment.all.as_json(include: [:screen, :content])
        end
    end

    def destroy
        assignment = Assignment.find(params[:id])
        assignment.destroy
        render json: { message: "Assignment removed" }
    end


    def create
        assignment = Assignment.create!(
            screen_id: params[:screen_id],
            content_id: params[:content_id],
            position: params[:position] || 0,
            start_at: params[:start_at],
            end_at: params[:end_at]
        )

        # broadcast change to channel for that screen
        # ActionCable.server.broadcast "screen_#{assignment.screen.slug}_channel", { action: 'assignment_changed' }
        # ActionCable.server.broadcast(
        #     "screen_#{assignment.screen.id}_channel",
        #     action: "assignment_changed",
        #     message: "Content assigned"
        # )
        render json: assignment, status: :created
        rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
    end







    
end
