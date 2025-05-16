# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  def create
    # 関連付ける親モデルのインスタンスを返している
    @commentable = find_commentable
    # 親モデルのインスタンスに紐づけられたcommentsのインスタンスのみ作成
    # comment_paramsにはフォームから送られてきた値が入っている
    @comment = @commentable.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { redirect_to @comment.commentable, flash: { danger: t('defaults.message.not_created', item: Comment.model_name.human) } }
      end
    end
  end

  def destroy
    commentable = current_user.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to commentable notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
    end
  end

  private
  def find_commentable
    
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end
end
