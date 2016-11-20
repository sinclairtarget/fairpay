class GroupsController < GroupAccessController
  skip_before_action :authorize_group, only: [:index,
                                              :new,
                                              :create,
                                              :join]

  def index
    redirect_group = Group.joins(:salaries)
                          .where(salaries: { user_id: @user.id })
                          .order(:name)
                          .first

    if redirect_group.present?
      redirect_to group_path(redirect_group.id)
    end
  end
  
  def show
    @groups = Group.joins(:salaries)
                   .where(salaries: { user_id: @user.id })
                   .order(:name)

    @salary = @group.salaries.where(user_id: @user.id).first
    @salaries_by_title = @group.salaries_by_title

    @title = params[:title] if params[:title].present?

    if @title
      @count = @salaries_by_title[@title].count
    else
      @count = @group.salaries.count
    end
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
      orig_count = emails.count

      existing_members = @group.users.where("email in (?)", emails)
                                     .pluck(:email)
      emails -= existing_members

      if emails.count > 0
        @group.invitations_count += emails.count
        @group.save!

        UserMailer.invite_email(@group, emails).deliver_later
      end

      if orig_count == 1
        notice = "#{orig_count} invitation sent."
      else
        notice = "#{orig_count} invitations sent."
      end

      redirect_to group_path(@group), notice: notice
    else
      head 400
    end
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
