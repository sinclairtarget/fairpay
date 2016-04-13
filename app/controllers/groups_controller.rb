class GroupsController < ApplicationController
  skip_before_action :authorize, only: [:join]
  before_action :authorize_group, except: [:index,
                                           :new,
                                           :create,
                                           :join]

  def index
  end
  
  def show
    @salary = @group.salaries.where(user_id: @user.id).first

    @salaries_by_title = @group.salaries_by_title
  end

  def new
  end

  def create
    group = Group.new(name: params[:group_name])
    group.save!

    onboard_user_to_group group.id
  end

  # invitations
  def invite
  end

  def send_invites
    if params[:emails]
      emails = params[:emails].split(',').map { |email| email.strip }

      existing_members = @group.users.where("email in (?)", emails)
                                     .pluck(:email)
      emails -= existing_members

      if emails.count > 0
        @group.invitations_count += emails.count
        @group.save!

        UserMailer.invite_email(@group, emails).deliver_later
      end

      notice = "Invitations sent."
      redirect_to group_path(@group), notice: notice
    else
      head 400
    end
  end

  def join
    onboard_user_to_group params[:id]
  end

  protected
  def authorize_group
    @group = Group.find(params[:id])
    head :forbidden unless @group.salaries.where(user: @user).exists?
  end

  def onboard_user_to_group(group_id)
    session[:group_to_join_id] = group_id
    redirect_to new_salary_path
  end
end
