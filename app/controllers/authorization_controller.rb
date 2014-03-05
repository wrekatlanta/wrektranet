class AuthorizationController < ApplicationController

  respond_to :json

  def authorizations
    auths = {}
    user = User.find_by(username: params[:user])

    unless user.nil?
      auths = {
        admin: user.admin?,
        exec: user.exec?,
        music_director: user.has_role?(:music_director),
        automation: user.has_role?(:automation)
      }
    end
    
    respond_with auths
  end

end