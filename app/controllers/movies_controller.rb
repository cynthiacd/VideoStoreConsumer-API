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
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    p "in the create method of rails API"

    movie = Movie.new(
      title: params[:title],
      overview: params[:overview],
      release_date: params[:release_date],
      image_url: params[:image_url],
      inventory: 1
    )

    if movie.save
      p "movie is in database"
      render :json => movie.to_json, :status => :ok
    end
  end

  # def create
  #   pet = Pet.new(
  #     name: params[:name],
  #     age: params[:age],
  #     breed: params[:breed],
  #     about: params[:about],
  #     vaccinated: params[:vaccinated]
  #   )
  #
  #   if pet.save
  #     render :json => pet.to_json, :status => :ok
  #   end
  # end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
