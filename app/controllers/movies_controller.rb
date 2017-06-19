class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    modified_params = movie_params
    modified_params[:image_url] = modified_params[:image_url].gsub("https://image.tmdb.org/t/p/w185","")
    @movie = Movie.create(modified_params)
    # byebug
    if @movie.id == nil
      render status: :bad_request
    end
      render status: :ok, json: @movie.to_json
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end

  def movie_params
    return params.require(:movie).permit(:title, :overview, :release_date, :image_url, :inventory)
  end


end
