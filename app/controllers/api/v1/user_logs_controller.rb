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
    render json: users.select(:id, :name, :email, :permission)
  end

  def update_users_permission
    user = User.find(params[:id])
    if user.update(permission: params[:permission])
    render json: { message: "User permission updated successfully." }, status: :ok
    else
    render json: { error: "Failed to update user permission." }, status: :unprocessable_entity
    end
  end


end
