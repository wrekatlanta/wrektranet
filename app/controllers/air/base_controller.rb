class Air::BaseController < ApplicationController
  layout 'air'
  before_action :authenticate_user!
end