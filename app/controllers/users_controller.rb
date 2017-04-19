class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	user = User.new(user_params)
  	if user.save
  		session[:user_id] = user.id
  		redirect_to '/'
  	else
  		redirect_to 'signup'
  	end
  end

  def update
    @user = User.find current_user.id
    if @user.update_attributes(user_params)
      flash[:notice] = "Ok"
    else
      flash[:notice] = "not ok"
    end
  end

  private
  def user_params
  	params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end