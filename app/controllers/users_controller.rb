class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @prototypes = @user.prototypes
  end

  def edit
  end

  def update
    current_user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :occupation, :position)
  end
end
