# frozen_string_literal: true

module Books
  class CommentsController < BaseCommentsController
    private

    def set_commentable
      @book = Book.find(params[:book_id])
      @commentable = @book
    end
  end
end
