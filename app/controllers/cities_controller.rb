class CitiesController < ApplicationController

  # 活動場所選択フォーム用
  def index
    if params[:prefecture_id].present?
      @cities = City.where(prefecture_id: params[:prefecture_id])
      render json: @cities.map { |city| { id: city.id, city_name: city.city_name } }
    else
      render json: []
    end
  end
end