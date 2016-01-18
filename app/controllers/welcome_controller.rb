class WelcomeController < ApplicationController
  def welcome
    redirect_to groups_url
  end
end
