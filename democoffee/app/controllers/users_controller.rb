class UsersController < ApplicationController

  def create
    @user = User.where(email: params[:email], status: true).first_or_create(email: params[:email], status: true)
    # true means user is in queuing
    qr_code_img = RQRCode::QRCode.new("http://192.168.0.104:3000/users/#{@user.id}/check", :size => 5, :level => :h ).to_img
    @user.update_attribute :qr_code, qr_code_img.resize(200,200).to_string
  end

  def value
    @user = User.find(params[:id])
    @user.value_level = params[:level]
    @user.save
  end

  def check
    @user = User.find(params[:id])
    @user.status = false
    @user.save
    @u = User.where("status = ?", true).first
    @u.send_notification_mail if @u
  end

end