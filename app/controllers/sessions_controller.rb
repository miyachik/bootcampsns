class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [:clear]

  def create
    begin

      @user = User.find_by(user: params[:user], pass: Digest::MD5.hexdigest(params[:pass]))
      token = SecureRandom.hex
      log_in @user, token
      render json: {name: @user.name, icon: icon_user_path(@user), csrf: token} and return
    rescue
      render json: {errors: ['ログインに失敗しました']}, status: :bad_request and return
    end
  end

  def clear
    log_out
    render json: {} and return
  end
end
