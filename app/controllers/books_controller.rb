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
    moveBookService = Books::MoveService.call(**move_params)

    if (moveBookService.result[:succeeded])
      render json: moveBookService.result[:book]
    else
      render status: :bad_request, json: { errors: moveBookService.result[:book].errors }
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
      **params.permit(:isbn).to_h.symbolize_keys
    }
  end

  def create_and_shelf_params
    cell = Cells::ReadService.call(account: @account_ctx, id: params[:cell_id], first: true).result if params[:cell_id].present?

    {
      account: @account_ctx,
      cell: cell,
      **params.permit(:isbn, :index).to_h.symbolize_keys
    }
  end

  def shelf_params
    cell = Cells::ReadService.call(account: @account_ctx, id: params[:cell_id], first: true).result if params[:cell_id].present?

    {
      account: @account_ctx,
      book: Books::ReadService.call(**read_params).result,
      cell: cell,
      **params.permit(:index).to_h.symbolize_keys
    }
  end

  def unshelf_params
    { book: Books::ReadService.call(**read_params).result }
  end

  def move_params
    cell = Cells::ReadService.call(account: @account_ctx, id: params[:cell_id], first: true).result if params[:cell_id].present?

    {
      book: Books::ReadService.call(**read_params).result,
      cell: cell,
      **params.permit(:index).to_h.symbolize_keys
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
      id: params[:id] || -1,
      first: true
    }
  end

  def list_params
    cell = Cells::ReadService.call(account: @account_ctx, id: params[:cell_id], first: true).result if params[:cell_id].present?
    grid = @account_ctx.grids.find_by(id: params[:grid_id]) if params[:grid_id].present? # todo

    {
      account: @account_ctx,
      item: nil, # not currently exposing items as addressable objects
      cell: cell,
      grid: grid,
      **params.permit(:isbn, :index).to_h.symbolize_keys,
    }
  end
end