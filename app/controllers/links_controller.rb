class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :set_collection
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  def index
    @links = Link.all
  end

  def show
    @user = User.find_by_id(@link.collection.patternable_id)
  end

  def new
    @link = Link.new
  end

  def edit
  end

  def create
    @link = @collection.links.build(link_params)

    require 'open-uri'
    doc = Nokogiri::HTML(open(@link.url).read, nil, 'utf-8')
    if @link.url.include? 'www.youtube.com/' || 'https:youtu.be/'
      p 'YOUTUBE!'
    end
    @link.title = doc.xpath("//meta[@property='og:title']/@content")
    @link.description = doc.xpath("//meta[@property='og:description']/@content") || doc.xpath("//meta[@name='description']/@content")
    @link.image = doc.xpath("//meta[@property='og:image']/@content")

    flash[:notice] = 'Link created' if @link.save

    respond_to do |format|
      format.html {redirect_to @collection}
      format.js
    end

  end

  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:collection_id])
  end

  def valid_user
    unless @collection.patternable_id == @parent.id
      redirect_to root_path, notice: 'Access denied'
    end
  end

    def set_link
      @link = Link.find(params[:id])
    end

    def link_params
      params.require(:link).permit(:url)
    end
end
