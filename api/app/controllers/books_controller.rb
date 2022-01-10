class BooksController < ApplicationController
  def create
    respond_with_failable_book_service Books::CreateService.call(**create_params)
  end

  def create_and_shelf
    respond_with_failable_book_service Books::CreateAndShelfService.call(**create_and_shelf_params)
  end
    
  def shelf
    respond_with_failable_book_service Books::ShelfService.call(**shelf_params)
  end

  def unshelf
    respond_with_failable_book_service Books::UnshelfService.call(**unshelf_params)
  end

  def move
    respond_with_failable_book_service Books::MoveService.call(**move_params)
  end

  def read
    respond_with_lookup_service Books::ReadService.call(**read_params)
  end

  def update
    respond_with_failable_book_service Books::UpdateService.call(**update_params)
  end

  def destroy
    respond_with_failable_book_service Books::DestroyService.call(**destroy_params)
  end

  def list    
    respond_with_list_service Books::ReadService.call(**list_params)
  end

  private

  def respond_with_failable_book_service(service)
    respond_with_failable_service service, on_success: :book
  end

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