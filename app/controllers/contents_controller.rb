class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy, :add_link]

  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
  end

  def add_link
    url = params[:external_link].strip
    site = Link.find_site(url)
    if site.nil?
      redirect_to content_path(@content), alert: 'Сайт для этой ссылки не найден в базе'
      return
    else
      begin
        @content.links.create(url: url, site: site, content: @content)
      rescue => e
        redirect_to content_path(@content), alert: e.message
        return
      end
      redirect_to content_path(@content), notice: 'Добавлена'
    end

  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)

    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Запись о файле создана.' }
        format.json { render action: 'show', status: :created, location: @content }
      else
        format.html { render action: 'new' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to @content, notice: 'Сведения о файле сохранены.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_content
    @content = Content.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def content_params
    params.require(:content).permit(:name, :url)
  end
end
