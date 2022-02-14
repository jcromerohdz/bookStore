class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroy

  private

  def not_destroy(e)
    render json: {errors: e.record.errors }, status: :unprocessable_entity
  end
end
