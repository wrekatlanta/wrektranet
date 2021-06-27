class Staff::BaseController < ApplicationController
  layout 'staff'
  before_action :authenticate_user!
end