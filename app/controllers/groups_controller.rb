class GroupsController < ApplicationController
  def index
  end
  
  def show
  end

  def new
  end

  def create
    group = Group.new(name: params[:group_name])
    group.save!

    redirect_to groups_path
  end

  def destroy
  end
end
