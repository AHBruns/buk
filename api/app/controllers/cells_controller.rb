class CellsController < ApplicationController
  def create
    respond_with_failable_cell_service(
      Cells::CreateService.call(**create_params)
    )
  end

  def read
    respond_with_lookup_service Cells::ReadService.call(**read_params)
  end

  def update
    respond_with_failable_cell_service(
      Cells::UpdateService.call(**update_params)
    )
  end

  def destroy
    respond_with_failable_cell_service(
      Cells::DestroyService.call(**destroy_params)
    )
  end

  def list
    respond_with_list_service Cells::ReadService.call(**list_params)
  end

  private

  def respond_with_failable_cell_service(service)
    respond_with_failable_service service, on_success: :cell
  end

  def load_grid
    @account_ctx.grids.find_by(id: params.require(:grid_id))
  end

  def create_params
    {
      account: @account_ctx,
      grid: load_grid,
      x: params.require(:x),
      y: params.require(:y)
    }
  end

  def update_params
    {
      cell: Cells::ReadService.call(**read_params).result,
      **params.permit(:x, :y, :grid_id).to_h.symbolize_keys
    }
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
      **params.permit(:x, :y, :grid_id).to_h.symbolize_keys
    }
  end

  def destroy_params
    { cell: Cells::ReadService.call(**read_params).result }
  end
end
