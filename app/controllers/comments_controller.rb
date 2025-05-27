# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)

    if @comment.save
      redirect_to @comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render template: "#{@commentable.class.model_name.plural}/show", status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy!
      redirect_to @comment.commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      redirect_to @comment.commentable, notice: t('controllers.common.notice_failure_destroy', name: Comment.model_name.human)
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end
end
