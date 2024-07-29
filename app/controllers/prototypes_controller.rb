class PrototypesController < ApplicationController
  before_action :set_prototype, except: [:new, :index, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_owner, only: [:edit, :destroy]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path, notice: 'プロトタイプが作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def destroy
    if @prototype.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def check_owner
    unless @prototype.user == current_user
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end
end
