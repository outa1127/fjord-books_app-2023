# frozen_string_literal: true

class CommentsController < ApplicationController
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy!
    redirect_to comment.commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end
end
