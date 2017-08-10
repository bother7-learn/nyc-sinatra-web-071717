class FiguresController < ApplicationController
  get "/figures/new" do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :"figures/new"
  end

  get "/figures/:id/edit" do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :"figures/edit"
  end

  patch "/figures/:id" do
    # binding.pry
    @figure = Figure.find(params[:id])
    @figure.titles.clear
    @figure.name = params[:figure][:name]
    params[:figure][:title_ids].each do |title_id|
      @title = Title.find(title_id)
      # binding.pry
      @figure.titles << @title
      # figure_title = FigureTitle.new(title_id: title_id, figure_id: @figure.id)
    end

    params[:figure][:landmark_ids].each do |landmark_id|
      @landmark = Landmark.find(landmark_id)
      @figure.landmarks << @landmark
      @landmark.save
      # figure_title = FigureTitle.new(title_id: title_id, figure_id: @figure.id)
    end

    if !params[:title][:name].empty?
      new_title = Title.new(name: params[:title][:name])
      @figure.titles << new_title
      new_title.save
    end

    if !params[:landmark][:name].empty?
      new_landmark = Landmark.new(name: params[:landmark][:name])
      @figure.landmarks << new_landmark
      new_landmark.save
    end


    @figure.save
    redirect "/figures/#{@figure.id}"
    binding.pry

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
