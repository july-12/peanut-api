class ApplicationController < ActionController::API
    include JsonWebToken

    # before_action :authenticate_request, only: [:create, :update, :destroy]
    before_action :authenticate_request, only: [:user_info]


    attr_reader :current_user

    def user_info
        if @current_user.present?
            render  json: @current_user
        else
            render json: nil
        end
    end

    private
        def authenticate_request
            header = request.headers['Authorization']
            if(header.present?)
                token = header.split(' ').last if header
                decoded = jwt_decode(token)
                @current_user = User.find(decoded[:user_id])
            else
                @current_user = nil
                render json: { error: 'Not Authorized' }, status: 401
            end
        end
end
