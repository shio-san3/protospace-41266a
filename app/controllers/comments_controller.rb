class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to prototype_path(@comment.prototype)
    else
      @prototype = @comment.prototype
      @comments = @prototype.comments.includes(:user)
      respond_to do |format|
        format.html { render "prototypes/show" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_container", partial: "prototypes/form", locals: { prototype: @prototype, comment: @comment }) }
      end # respond_toブロックを終了
    end # if/elseブロックを終了
  end
  
  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end