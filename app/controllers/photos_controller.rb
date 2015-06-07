class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  before_action :set_collection

  def index
    @photos = Photo.all
  end

  def show
    @user = User.find_by_id(@photo.collection.patternable_id)
  end

  def new
    @photo = Photo.new
  end

  def edit
  end

  def create
    @photo = @collection.photos.build(photo_params)
    flash[:notice] = 'Photo created' if @photo.save
    redirect_to @collection
  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def valid_user
      unless @collection.patternable_id == @parent.id
        redirect_to root_path, notice: 'Access denied'
      end
    end


    def set_collection
      @collection = Collection.find_by_id(params[:collection_id])
    end

    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:title, :description, :image)
    end
end
