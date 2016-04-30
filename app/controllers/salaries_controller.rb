class SalariesController < ApplicationController
  def new
    @group = Group.find(session[:group_to_join_id])
  end

  def create
    @group = Group.find(session[:group_to_join_id])
    was_empty = @group.empty?

    salary = Salary.new(title: params[:"title-autocomplete"],
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

  def update
    salary = Salary.find(params[:id])

    if salary.user != @user
      head :forbidden
      return
    end

    if params[:title].present?
      salary.title = params[:title]
    end

    if params[:annual_pay].present?
      salary.annual_pay = params[:annual_pay]
    end

    salary.save!

    redirect_to group_path(salary.group), notice: "Information updated."
  end

  def destroy
    salary = Salary.find(params[:id])

    if salary.user != @user
      head :forbidden
      return
    end

    group_name = salary.group.name
    salary.destroy

    redirect_to groups_path, notice: "You left #{group_name}."
  end
end
