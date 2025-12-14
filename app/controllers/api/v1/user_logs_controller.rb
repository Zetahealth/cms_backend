class Api::V1::UserLogsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]

    def index
        logs = UserLog.includes(:user).order(created_at: :desc)
        render json: logs.to_json(include: { user: { only: [:name, :email] } })
    end

    private

    def sc_data(sc)
        {
        id: sc.id,
        event_type: sc.event_type,
        details: sc.details,
        updated_at: sc.updated_at,
        email: sc.user.email, 
        user_id: sc.user.id,
        name: sc.user.name,
        }
    end





end