class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if params[:sort] == "title"
      session[:sort] = params[:sort]
    elsif params[:sort] == "date"
      session[:sort] = params[:sort]
    end
    if session[:sort] == "title"
      @movies = Movie.order(:title)
    elsif session[:sort] == "date"
      @movies = Movie.order(:release_date)
    else
      @movies = Movie.all
    end
    if !session[:ratings]
      session[:ratings] = Hash[@all_ratings.map {|x| [x, 1]}]
    end
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    if session[:ratings]
      @boxes = session[:ratings].keys
      i = @boxes.size
      while i < 5  do
        @boxes.insert(0, @boxes[0])
        i +=1
      end
      @boxes.insert(0, "rating = ? OR rating = ? OR rating = ? OR rating = ? OR rating = ?")
      @movies = @movies.where(@boxes)
    end
  end
  
  def titleheader
    @movies = Movie.all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
