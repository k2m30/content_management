class LinksController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_link, only: [:show, :edit, :update, :destroy]


  # GET /links
  # GET /links.json
  def index
    @links = params[:site].nil? ? Link.all.order('contents.name', 'sites.name').includes(:content, :site).paginate(page: params[:page], per_page: 30) :
        Link.where(site_id: params[:site]).order('contents.name').includes(:content).paginate(page: params[:page], per_page: 30)
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)
    @link.url+='/' if not @link.url.end_with?('/')
    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render action: 'show', status: :created, location: @link }
      else
        format.html { render action: 'new' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      begin
        @link.update(link_params)
        @link.update(url: @link.url+'/') if not @link.url.end_with?('/')
        format.html { redirect_to @link.content, notice: 'Изменено' }
        format.json { head :no_content }
      rescue
        format.html { redirect_to edit_link_path(@link), alert: 'Ошибка' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    content = @link.content
    @link.destroy
    respond_to do |format|
      format.html { redirect_to content_path(content) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:url)
    end
end
