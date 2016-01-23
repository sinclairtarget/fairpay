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

    flash[:group_id] = group.id
    redirect_to new_salary_path
  end

  def destroy
  end
end
