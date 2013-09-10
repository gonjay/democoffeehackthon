class AdminsController < ApplicationController

  def index
    @users = User.where("status = ?", true) 
    @finish_users = User.where("status = ?", false) 
  end

  def notificate_user
    @user = User.find_by_id(params[:id])
    @user.send_notification_mail
    @user.status = false
    redirect_to :back if @user.save
  end

end