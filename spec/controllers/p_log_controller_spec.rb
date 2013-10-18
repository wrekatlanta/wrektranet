require 'spec_helper'

describe PLogController do

  describe "GET 'plog'" do
    it "returns http success" do
      get 'plog'
      response.should be_success
    end
  end

end
