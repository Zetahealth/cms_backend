class Api::V1::ScreenContainersController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show , :create, :assign_screen, :unassign_screen , :destroy]

  def index
    containers = ScreenContainer.all
    render json: containers.as_json(include: { screens: { only: [:id, :name, :slug] } })
  end

  def show
    container = ScreenContainer.find(params[:id])
    render json: container.as_json(include: { screens: { only: [:id, :name, :slug] } })
  end

  def create
    container = ScreenContainer.new(name: params[:name])
    if container.save
      render json: container, status: :created
    else
      render json: { error: container.errors.full_messages }, status: :unprocessable_entity
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
    screen = Screen.find(params[:screen_id])
    container.screens.delete(screen)
    render json: { message: "Screen unassigned successfully" }
  end

  def destroy
    ScreenContainer.find(params[:id]).destroy
    render json: { message: "Deleted" }
  end
end
