# require 'movie_wrapper'
class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      puts "about to call Movie Wrapper"
      data = MovieWrapper.search(params[:query])
    else
      puts "about to show all movies in rails db"
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory, :id],
        methods: [:available_inventory]
        )
      )
  end

  def create
    p "in the create method of rails API"
    # p params[:external_id]

    movie = Movie.new(
      title: params[:title],
      overview: params[:overview],
      release_date: params[:release_date],
      external_id: params[:external_id],
      image_url: params[:image_url].gsub("https://image.tmdb.org/t/p/w185", ""),
      inventory: params[:inventory]
    )

    if movie.save
      p "movie is in database"
      render :json => movie.to_json, :status => :ok
    else
      render :json => movie.errors, :status => :bad_request
    end
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
