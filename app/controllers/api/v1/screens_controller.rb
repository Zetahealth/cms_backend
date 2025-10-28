class Api::V1::ScreensController < ApplicationController
    # before_action :authorize_request, except: [:index, :show]
    skip_before_action :authorize_request, only: [:index, :show, :create, :update, :destroy]

    def index
    render json: Screen.all
    end

    def show
    s = Screen.find(params[:id])
    render json: s
    end

    def create
    s = Screen.new(screen_params)
    if s.save
        render json: s, status: :created
    else
        render json: { errors: s.errors.full_messages }, status: :unprocessable_entity
    end
    end

    def update
    s = Screen.find(params[:id])
    if s.update(screen_params)
        render json: s
    else
        render json: { errors: s.errors.full_messages }, status: :unprocessable_entity
    end
    end

    def destroy
        s = Screen.find(params[:id])
        s.destroy
        head :no_content
    end

    private
    def screen_params
    params.require(:screen).permit(:name, :slug)
    end
end
