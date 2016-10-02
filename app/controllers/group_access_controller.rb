class GroupAccessController < ApplicationController
  before_action :authorize_group

  protected
  def authorize_group
    id = params[:id] || params[:group_id]
    @group = Group.find(id)
    head :forbidden unless @group.salaries.where(user: @user).exists?
  end
end
