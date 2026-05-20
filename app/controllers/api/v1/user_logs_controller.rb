# class Api::V1::UserLogsController < ApplicationController
#     skip_before_action :authenticate_user!, only: [:index]

#     def index
#         logs = UserLog.includes(:user).order(created_at: :desc)
#         render json: logs.to_json(include: { user: { only: [:name, :email] } })
#     end

#     def users
#         users = User.all.except_current_user(current_user)
#         render json: users.select(:id, :name, :email )
#     end

#     private

#     def sc_data(sc)
#         {
#         id: sc.id,
#         event_type: sc.event_type,
#         details: sc.details,
#         updated_at: sc.updated_at,
#         email: sc.user.email, 
#         user_id: sc.user.id,
#         name: sc.user.name,
#         }
#     end





# end
class Api::V1::UserLogsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:create_user]

  def index
    logs = UserLog
      .includes(:user)
      .order(created_at: :desc)

    render json: logs.as_json(
      include: { user: { only: [:id, :name, :email] } }
    )
  end

  def users
    users = User.all
    render json: users.select(:id, :name, :email, :permission ,:created_at)
  end

  def update_users_permission
    user = User.find(params[:id])
    if user.update(permission: params[:permission])
    render json: { message: "User permission updated successfully." }, status: :ok
    else
    render json: { error: "Failed to update user permission." }, status: :unprocessable_entity
    end
  end

  def delete_user
    user = User.find(params[:id])
    user.destroy
    render json: { message: "User deleted successfully." }, status: :ok
  end

   # POST /api/v1/create_user
  def create_user
    unless current_user && current_user.admin?
      return render json: { error: "Only admin can create users." }, status: :unauthorized
    end

    user = User.new(user_params)

    if user.save
      render json: {
        message: "User created successfully.",
        user: user
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :role,
      :permission
    )
  end
end
