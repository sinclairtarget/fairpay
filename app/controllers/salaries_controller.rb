class SalariesController < ApplicationController
  def new
    @group_id = flash[:group_id]
  end

  def create
    @group = Group.find(params[:group_id])

    salary = Salary.new(title: params[:title],
                        annual_pay: params[:salary][:annual_pay],
                        user_id: @user.id,
                        group_id: @group.id)
    salary.save!

    if @group.fresh?
      redirect_to invite_group_path(@group)
    else
      redirect_to groups_path
    end
  end

  def destroy
  end
end
