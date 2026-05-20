# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :authenticate_user!, only: [:create]
  
  respond_to :json

  def create
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])

      # Reset failed attempts after successful login
      user.update(failed_attempts: 0)

      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

      render json: {
        status: {
          code: 200,
          message: 'Logged in successfully.'
        },
        user: user,
        token: token
      }, status: :ok

    else

      if user
        user.failed_attempts ||= 0
        user.failed_attempts += 1
        user.save

        if user.failed_attempts >= 5

          # send reset password mail
          user.send_reset_password_instructions

          # reset counter after sending mail
          user.update(failed_attempts: 0)

          return render json: {
            error: "Too many wrong attempts. Reset password link sent to your email."
          }, status: :unprocessable_entity
        end
      end

      render json: {
        error: "Invalid email or password"
      }, status: :unauthorized
    end
  end
end
