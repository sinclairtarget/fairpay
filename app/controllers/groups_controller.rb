require_relative "../../lib/util/util"
require_relative "../../lib/ext/numeric"

class GroupsController < ApplicationController
  include Util

  skip_before_action :authorize, only: [:join]
  before_action :authorize_group, except: [:index,
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
    else
      redirect_to new_group_path
    end
  end
  
  def show
    @groups = Group.joins(:salaries)
                   .where(salaries: { user_id: @user.id })
                   .order(:name)

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

  # --------------------------------------------------------------------------
  # Graph endpoints
  # --------------------------------------------------------------------------
  def distribution
    salaries = @group.salaries.order(:annual_pay)

    min = salaries.first.annual_pay.rounddown(1000)
    max = salaries.last.annual_pay.roundup(1000) + 1000
    range = max - min

    bucket_size = range / 10

    buckets = {}
    bucket_min = min
    bucket_max = min + bucket_size
    key = bucket_key(bucket_min, bucket_max)
    buckets[key] ||= 0

    salaries.each do |salary|
      while salary.annual_pay >= bucket_max
        bucket_min += bucket_size
        bucket_max += bucket_size
        key = bucket_key(bucket_min, bucket_max)
        buckets[key] ||= 0
      end

      buckets[key] += 1
    end

    render json: buckets
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

  def bucket_key(bucket_min, bucket_max)
    min_str = dollar(bucket_min, short: true)
    max_str = dollar(bucket_max, short: true)
    "#{min_str} – <#{max_str}"
  end
end
