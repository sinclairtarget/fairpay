class SalariesController < ApplicationController
  def new
  end

  def create
    @group = Group.find(session[:group_to_join_id])
    was_empty = @group.empty?

    salary = Salary.new(title: params[:title],
                        annual_pay: params[:salary][:annual_pay],
                        user_id: @user.id,
                        group_id: @group.id)
    salary.save!

    session[:group_to_join_id] = nil

    if was_empty
      redirect_to invite_group_path(@group)
    else
      redirect_to group_path(@group)
    end
  end

  def destroy
  end
end
