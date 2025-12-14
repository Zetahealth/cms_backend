class Api::V1::AssignmentsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]
    before_action :authenticate_user!, only: [:create, :destroy]

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
        if params[:id].present?
            assesnment = Assignment.find(params[:id])
            screen = Screen.find(assesnment.screen_id) if assesnment.screen_id.present?
            content = Content.find(assesnment.content_id) if assesnment.content_id.present?
            UserLog.create(
                user: current_user, 
                event_type: "SCREEN_CONTENT_UNASSIGNED", 
                details: "A user unassigned the content named '#{content.title}' from the screen '#{screen.name}'."
            )
            ScreenBroadcaster.refresh(screen) if screen.present?
        end
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
        

        if params[:screen_id].present?
            screen = Screen.find(params[:screen_id])
            content = Content.find(params[:content_id])
            ScreenBroadcaster.refresh(screen)

            UserLog.create(
                user: current_user, 
                event_type: "SCREEN_CONTENT_ASSIGNED", 
                details: "A user assigned the content named '#{content.title}' to the screen '#{screen.name}'."
            )
        end

        render json: assignment, status: :created
        rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
    end







    
end
