class SalariesController < ApplicationController
  def new
    @group_id = flash[:group_id]
  end

  def create
    salary = Salary.new(title: params[:title],
                        annual_pay: params[:salary][:annual_pay],
                        user_id: @user.id,
                        group_id: params[:group_id])
    salary.save!

    redirect_to groups_path
  end

  def destroy
  end
end
