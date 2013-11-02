class Staff::BaseController < ApplicationController
  layout 'staff'
  before_filter :authenticate_user!
end