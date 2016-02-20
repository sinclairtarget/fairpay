class GroupsController < ApplicationController
  skip_before_action :authorize, only: [:join]
  skip_before_action :verification_check, only: [:join]

  def index
  end
  
  def show
    @group = Group.find(params[:id])
  end

  def new
  end

  def create
    group = Group.new(name: params[:group_name])
    group.save!

    onboard_user_to_group group.id
  end

  def destroy
  end

  # invitations
  def invite
    @group = Group.find(params[:id])
  end

  def send_invites
    @group = Group.find(params[:id])

    if params[:emails]
      emails = params[:emails].split(',').map { |email| email.strip }

      if emails.count > 0
        @group.invitations_count += emails.count
        @group.save!

        UserMailer.invite_email(@group, emails).deliver_later

        notice = "#{emails.count} invitations sent. #{@group.invitations_count}" +
          " people have now been invited to this group."
      end
    end

    redirect_to group_path(@group), notice: notice
  end

  def join
    onboard_user_to_group params[:id]
  end

  protected
  def onboard_user_to_group(group_id)
    session[:group_to_join_id] = group_id
    redirect_to new_salary_path
  end
end
