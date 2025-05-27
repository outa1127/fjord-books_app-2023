# frozen_string_literal: true

module Books
  class CommentsController < CommentsController
    private

    def set_commentable
      @book = Book.find(params[:book_id])
      @commentable = @book
    end
  end
end
