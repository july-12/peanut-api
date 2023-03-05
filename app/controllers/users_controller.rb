class UsersController < ApplicationController
  
  before_action :authenticate_request, only: [:index, :destroy]
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def login_by_github
      auth_hash = request.env['omniauth.auth']
      uid = auth_hash.uid
      email = auth_hash.info['email']
      token = auth_hash.credentials['token']
      user = User.find_or_create_by(email:, uid:)
      user.password = token
      if user.save
        token = jwt_encode(user_id: user.id)
        render json: { token: token }, status: :ok
      else
        render json: { msg: 'unauthorized' }
      end
  end

  def login
    @user = User.find_by(email: params[:email], name: params[:name], phone: params[:phone])

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { msg: 'unauthorized' }
    end
  
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
