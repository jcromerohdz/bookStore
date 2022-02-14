class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotDestroy, with: :not_destroy

  private

  def not_destroy(e)
    render json: {errors: e.record.errors }, status: :unprocessable_entity
  end
end
