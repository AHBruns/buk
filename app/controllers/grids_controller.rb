class GridsController < ApplicationController
  def create
    create_grid_service = Grids::CreateService.call(**create_params)

    if (create_grid_service.result[:succeeded])
      render json: create_grid_service.result[:grid]
    else
      render status: :bad_request, json: { errors: create_grid_service.result[:grid].errors }
    end
  end

  def read
    render json: load_grid
  end

  def update
    update_grid_service = Grids::UpdateService.call(**update_params)

    if (update_grid_service.result[:succeeded])
      render json: update_grid_service.result[:grid]
    else
      render status: :bad_request, json: { errors: update_grid_service.result[:grid].errors }
    end
  end

  def destroy
    @grid = load_grid

    if (@grid.destroy)
      render json: @grid
    else
      render status: :bad_request, json: { errors: @grid.errors }
    end
  end

  def list
    render json: @account_ctx.grids
  end

  private

  def load_grid
    @account_ctx.grids.find_by(id: params[:id])
  end

  def create_params
    {
      account: @account_ctx,
      **params.permit(:name).to_h.symbolize_keys
    }
  end

  def update_params
    {
      grid: load_grid,
      **params.permit(:name).to_h.symbolize_keys
    }
  end
end
