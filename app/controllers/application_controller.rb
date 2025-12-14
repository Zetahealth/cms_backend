class ApplicationController < ActionController::API
#   before_action :authorize_request

  before_action :authenticate_user!
  before_action :set_default_format

#   before_action do
#     Rails.logger.info "AUTH HEADER: #{request.headers['Authorization']}"
#   end

  private

    def set_default_format
        request.format = :json
    end

    # def authorize_request
    #     puts "------------------------00000000-------------------------"
    #     token = request.headers['Authorization']&.split(' ')&.last
    #     return render json: { error: 'Missing token' }, status: :unauthorized unless token

    #     begin
    #     decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256').first
    #     @current_user = User.find(decoded['sub'])
    #     puts "------------------------#{@current_user.inspect}-------------------------"
    #     rescue JWT::DecodeError
    #     render json: { error: 'Invalid token' }, status: :unauthorized
    #     end
    # end

end
