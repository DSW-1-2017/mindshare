class DojosController < ApplicationController
  #before_action :authorize
  #protect_from_forgery

  def new
    @dojo = Dojo.new
    @themes = Theme.all
    @location = Location.new
    @video = Video.new
  end

  # create facade
  def create
    category = params[:dojo][:category].to_sym
    dojo_factory = dojos_factories[category]

    if (dojo_factory)
      @dojo = dojo_factory.create(dojo_params, current_user)
      @dojo.create_location(location_params)
    end

    # if video_params[:source]
    #   @dojo.create_video(video_params)
    # end

    if @dojo.save
      theme = Theme.find dojo_params[:theme_id]
      theme.dojos << @dojo
      flash[:notice] = "Ok"
      redirect_to '/'
    else
      flash[:error] = "Not ok"
      redirect_to '/'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
    @dojo = Dojo.find params[:id]
  end

  def near_dojos
    dojo_ids = Location.near(current_user.location.address).collect{|a| a.dojo_id}.uniq
    @dojos = Dojo.where('id in (?)', dojo_ids)

    # @near_dojos = []

    # near = Location.near(current_user.location.address)
    # @dojos = Dojo.joins(:location).merge(near)
    # @location = Location.near(current_user.location.address)

    # @dojos = Dojo.joins(:location).near(current_user.location.address)

    # Dojo.all.each do |d|
      # @near_dojos = d.location.near(current_user.location.address)
      # @near_dojos << near_dojo
    # end

    # @near_dojos
  end

  private
    def dojo_params
      params.require(:dojo).permit(:user_id, :theme_id, :title, :category)
    end

    def location_params
      params.require(:location).permit(:address, :latitude, :longitude)
    end

    def video_params
      params.require(:video).permit(:source)
    end

    def dojos_factories
      Hash.try_convert({
        kata: DojoFactory::KataCreator,
        randori: DojoFactory::RandoriCreator
      })
    end
end
