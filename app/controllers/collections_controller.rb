class CollectionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :get_parent
  before_action :valid_user, except: [:index, :show, :new, :create]

  def index
    @collections = Collection.all
  end

  def show
    @parts = (@collection.photos + @collection.links).sort_by{|e| e[:created_at]}.reverse
    @user = User.find_by_id(@collection.patternable_id)

    #meta part
    @title = @collection.title + ' by ' + @user.email
    @ogdescription = @collection.title + ' collection'
    @ogauthor = @user.email
    @ogimage = @parts.first.image
  end

  def new
    @collection = @parent.collections.build
  end

  def edit
  end

  def create
    @collection = @parent.collections.build(collection_params)
    redirect_to @collection if @collection.save
  end

  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def get_parent
      @parent = current_user
    end

    def valid_user
      unless @collection.patternable_id == @parent.id
        redirect_to root_path, notice: 'Access denied'
      end
    end

    def set_collection
      @collection = Collection.find(params[:id])
    end

    def collection_params
      params.require(:collection).permit(:title, :description, :user_id)
    end
end
