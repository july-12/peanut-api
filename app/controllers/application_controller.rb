class ApplicationController < ActionController::API
    include JsonWebToken

    # before_action :authenticate_request, only: [:create, :update, :destroy]
    before_action :authenticate_request


    attr_reader :current_user

    def user_info
    end

    private
        def authenticate_request
            header = request.headers['Authorization']
            if(header.present?)
                token = header.split(' ').last if header
                decoded = jwt_decode(token)
                @current_user = User.find(decoded[:user_id])
            else
                render json: { error: 'Not Authorized' }, status: 401
            end
        end
end
