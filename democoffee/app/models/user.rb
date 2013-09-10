#!/bin/env ruby  
# encoding: utf-8 
class User < ActiveRecord::Base
  image_accessor :qr_code

  def queue_info
    "现在时间是：#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
  end

  def queuing_people_num
    User.where(status: true).count
  end

  def average_wait_time
    @users = User.where("status = ?", false)
    if @users != []
      t = 0
      @users.each do |user|
        t = user.updated_at - user.created_at
      end
      return t / @users.count
    end
    return 0
  end

  def send_notification_mail
    response = RestClient.post "https://sendcloud.sohu.com/webapi/mail.send.xml",
    :api_user => "postmaster@mothinlab.sendcloud.org",
    :api_key => "y0hgJWwB",
    :from => "mothinlab@sendcloud.com",
    :fromname => "MothinLab",
    :to => "#{self.email}",
    :subject => "排队提醒",
    :html => "<h2>已经要排到您了</h2><h4>请对此次排队作出评价：<a href=\"#{value(3)}\">满意 </a><a href=\"#{value(2)}\">还行 </a><a href=\"#{value(1)}\">不满意</a><img src=\"#{self.qr_code.jpg.url}\"> </h4>"
    return response
  end

  def value(level)
    "http://192.168.0.104:3000" + "/users/#{self.id}" + "/value?level=#{level}"
  end

end