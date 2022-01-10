class GridsController < ApplicationController
  def create
    respond_with_failable_grid_service(
      Grids::CreateService.call(**create_params)
    )
  end

  def read
    respond_with_lookup_service Grids::ReadService.call(**read_params)
  end

  def update
    respond_with_failable_grid_service(
      Grids::UpdateService.call(**update_params)
    )
  end

  def destroy
    respond_with_failable_grid_service(
      Grids::DestroyService.call(**destroy_params)
    )
  end

  def list
    respond_with_list_service Grids::ReadService.call(**list_params)
  end

  private

  def respond_with_failable_grid_service(service)
    respond_with_failable_service service, on_success: :grid
  end

  def create_params
    {
      account: @account_ctx,
      **params.permit(:name).to_h.symbolize_keys
    }
  end

  def read_params
    {
      account: @account_ctx,
      id: params.require(:id),
      first: true
    }
  end

  def update_params
    {
      grid: Grids::ReadService.call(**read_params).result,
      **params.permit(:name).to_h.symbolize_keys
    }
  end

  def destroy_params
    { grid: Grids::ReadService.call(**read_params).result }
  end

  def list_params
    {
      account: @account_ctx,
      **params.permit(:name).to_h.symbolize_keys
    }
  end
end
