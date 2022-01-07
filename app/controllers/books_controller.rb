class BooksController < ApplicationController
  def create
    create_book_service = Books::CreateService.call(**create_params)

    if (create_book_service.result[:succeeded])
      render json: create_book_service.result[:book]
    else
      render status: :bad_request, json: { errors: create_book_service.result[:book].errors }
    end
  end

  def create_and_shelf
    create_and_shelf_service = Books::CreateAndShelfService.call(**create_and_shelf_params)

    if (create_and_shelf_service.result[:succeeded])
      render json: create_and_shelf_service.result[:book]
    else
      render status: :bad_request, json: { errors: create_and_shelf_service.result[:book].errors }
    end
  end
    
  def shelf
    shelf_book_service = Books::ShelfService.call(**shelf_params)

    if (shelf_book_service.result[:succeeded])
      render json: shelf_book_service.result[:book]
    else
      render status: :bad_request, json: { errors: shelf_book_service.result[:book].errors }
    end
  end

  def unshelf
    unshelf_book_service = Books::UnshelfService.call(**unshelf_params)

    if (unshelf_book_service.result[:succeeded])
      render json: unshelf_book_service.result[:book]
    else
      render status: :bad_request, json: { errors: unshelf_book_service.result[:book].errors }
    end
  end

  def move
    move_book_service = Books::MoveService.call(**move_params)

    if (move_book_service.result[:succeeded])
      render json: move_book_service.result[:book]
    else
      render status: :bad_request, json: { errors: move_book_service.result[:book].errors }
    end
  end

  def read
    book = Books::ReadService.call(**read_params).result

    if book.present?
      render json: book
    else
      render status: :bad_request, json: { errors: ["No book by that id."] }
    end
  end

  def update
    update_book_service = Books::UpdateService.call(**update_params)
    
    if update_book_service.result[:succeeded]
      render json: update_book_service.result[:book]
    else
      render status: :bad_request, json: { errors: update_book_service.result[:book].errors }
    end
  end

  def destroy
    destroy_book_service = Books::DestroyService.call(**destroy_params)

    if destroy_book_service.result[:succeeded]
      render json: destroy_book_service.result[:book]
    else
      render status: :bad_request, json: { errors: destroy_book_service.result[:book].errors }
    end
  end

  def list    
    render json: Books::ReadService.call(**list_params).result
  end

  private

  def create_params
    {
      account: @account_ctx,
      isbn: params.require(:isbn)
    }
  end

  def create_and_shelf_params
    {
      account: @account_ctx,
      cell: Cells::ReadService.call(account: @account_ctx, id: params.require(:cell_id), first: true).result,
      index: params.require(:index),
      isbn: params.require(:isbn)
    }
  end

  def shelf_params
    {
      account: @account_ctx,
      book: Books::ReadService.call(**read_params).result,
      cell: Cells::ReadService.call(account: @account_ctx, id: params.require(:cell_id), first: true).result,
      index: params.require(:index)
    }
  end

  def unshelf_params
    { book: Books::ReadService.call(**read_params).result }
  end

  def move_params
    {
      book: Books::ReadService.call(**read_params).result,
      cell: Cells::ReadService.call(account: @account_ctx, id: params.require(:cell_id), first: true).result,
      index: params.require(:index)
    }
  end

  def update_params
    {
      book: Books::ReadService.call(**read_params).result,
      **params.permit(:isbn).to_h.symbolize_keys
    }
  end

  def destroy_params
    { book: Books::ReadService.call(**read_params).result }
  end

  def read_params
    {
      account: @account_ctx,
      id: params.require(:id),
      first: true
    }
  end

  def list_params
    {
      account: @account_ctx,
      **params.permit(:isbn, :index, :cell_id, :grid_id).to_h.symbolize_keys,
    }
  end
end