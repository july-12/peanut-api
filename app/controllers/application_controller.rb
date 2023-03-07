class ApplicationController < ActionController::API
    include JsonWebToken

    before_action :authenticate_request, only: [:create, :update, :destroy]

    attr_reader :current_user

    def user_info
        if @current_user.present?
            render json: @current_user
        else
            header = request.headers['Authorization']
            if header.present?
                token = header.split(' ').last if header
                decoded = jwt_decode(token)
                @current_user = User.find(decoded[:user_id])
                render json: @current_user, only: [:name, :email, :avatar], method: :name
            else
                render json: nil
            end
        end
    end

    private
        def authenticate_request
            header = request.headers['Authorization']
            if header.present?
                token = header.split(' ').last if header
                decoded = jwt_decode(token)
                @current_user = User.find(decoded[:user_id])
            else
                @current_user = nil
                render json: { error: 'Not Authorized' }, status: 401
            end
        end
end
