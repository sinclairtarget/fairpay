class GroupsController < ApplicationController
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

    flash[:group_id] = group.id
    redirect_to new_salary_path
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

      @group.invitations_count += emails.count
      @group.save!

      UserMailer.invite_email(@group, emails).deliver_later

      notice = "#{emails.count} invitations sent. #{@group.invitations_count}" +
        " people have now been invited to this group."
      redirect_to group_path(@group), notice: notice
    end
  end
end
