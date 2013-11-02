class Air::BaseController < ApplicationController
  layout 'air'
  before_filter :authenticate_user!
end