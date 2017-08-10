class LandmarksController < ApplicationController
  get "/landmarks/new" do
    erb :"landmarks/new"
  end

  post "/landmarks" do
    landmark = Landmark.new(params[:landmark])
    landmark.save
    redirect "/landmarks/#{landmark.id}"
  end

  get "/landmarks" do
    @landmarks = Landmark.all
    erb :"landmarks/index"
  end

  get "/landmarks/:id/edit" do
    @landmark = Landmark.find(params[:id].to_i)
    erb :"landmarks/edit"
  end

  patch "/landmarks/:id" do
    @landmark = Landmark.find(params[:id].to_i)
    @landmark.update(params[:landmark])
    redirect "/landmarks/#{@landmark.id}"
  end

  get "/landmarks/:id" do
    @landmark = Landmark.find(params[:id].to_i)
    erb :"landmarks/show"
  end


end
