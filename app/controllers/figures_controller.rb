class FiguresController < ApplicationController
  get "/figures/new" do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :"figures/new"
  end

  post "/figures" do
    @figure = Figure.new(name: params[:figure][:name])
    @figure.save

    if params[:figure][:title_ids]
      params[:figure][:title_ids].each do |title_id|
        figure_title = FigureTitle.new(title_id: title_id, figure_id: @figure.id)
        figure_title.save
      end
    end

    if params[:figure][:landmark_ids]
      params[:figure][:landmark_ids].each do |landmark_id|
        landmark = Landmark.find(landmark_id.to_i)
        landmark.figure = @figure
        landmark.save
      end
    end

    if !params[:title][:name].empty?
      title = Title.new(name: params[:title][:name])
      title.save
      figure_title = FigureTitle.new(title_id: title.id, figure_id: @figure.id)
      figure_title.save
    end

    if !params[:landmark][:name].empty?
      landmark = Landmark.new(name: params[:landmark][:name], figure_id: @figure.id)
      landmark.save
    end
  end

  get "/figures" do
    @figures = Figure.all
    erb :"figures/index"
  end

  get "/figures/:id" do
    @figure = Figure.find(params[:id].to_i)
    erb :"figures/show"
  end
end
