class CellsController < ApplicationController
  def create
    create_cell_service = Cells::CreateService.call(**create_params)

    if (create_cell_service.result[:succeeded])
      render json: create_cell_service.result[:cell]
    else
      render status: :bad_request, json: { errors: create_cell_service.result[:cell].errors }
    end
  end

  def read
    cell = Cells::ReadService.call(**read_params).result

    if cell.present?
      render json: cell
    else
      render status: :bad_request, json: { errors: ["No cell by that id."] }
    end
  end

  def update
    update_cell_service = Cells::UpdateService.call(**update_params)
    
    if (update_cell_service.result[:succeeded])
      render json: update_cell_service.result[:cell]
    else
      render status: :bad_request, json: { errors: update_cell_service.result[:cell].errors }
    end
  end

  def destroy
    @cell = load_cell

    if (@cell.destroy)
      render json: @cell
    else
      render status: :bad_request, json: { errors: @cell.errors }
    end
  end

  def list
    cells = @account_ctx.cells
    cells = cells.where(grid_id: params[:grid_id]) if params[:grid_id].present?
    cells = cells.where(x: params[:x]) if params[:x].present?
    cells = cells.where(y: params[:y]) if params[:y].present?

    render json: cells
  end

  private

  def load_cell
    Cells::ReadService.call(**read_params).result
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
end
