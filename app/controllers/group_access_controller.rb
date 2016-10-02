class GroupAccessController < ApplicationController
  before_action :authorize_group

  protected
  def authorize_group
    @group = Group.find(params[:id])
    head :forbidden unless @group.salaries.where(user: @user).exists?
  end
end
