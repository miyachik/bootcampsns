class ApplicationController < ActionController::Base
  before_action :reject_cross_origin_request, except: [:icon, :manage]

  @current_user = nil

  helper_method :log_in

  private

  def log_in(user, token)
    reset_session
    session[:csrf] = token
    session[:id] = user.id
  end

  def log_out()
    session.delete(:id)
  end

  def reject_cross_origin_request
    # X-Requested-Withリクエストヘッダが付いていなければ他のサイトからのリクエスト
    render :nothing => true, :status => :bad_request and return unless request.headers['X-Requested-With']
  end

  def authenticate_user!
    @current_user = User.find_by(id: session[:id])
    render :nothing => true, :status => :forbidden and return if @current_user.nil?
  end

  def authenticate_csrf!
    render :nothing => true, :status => :forbidden unless params[:csrf] == session[:csrf]
  end

  def reject_non_admin_user
    render :nothing => true, :status => :forbidden and return unless @current_user.admin?
  end

end
