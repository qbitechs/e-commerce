class Admin::MetaTagsController < Admin::ApplicationController
  before_action :set_meta_tag, only: [ :edit, :update, :destroy ]

  def index
    @tags = Current.admin_user&.meta_tags.all
  end

  def new
    @meta_tag = Current.admin_user&.meta_tags.new
  end

  def create
    @meta_tag = Current.admin_user&.meta_tags.new(meta_tag_params)
    if @meta_tag.save
      redirect_to admin_meta_tags_path, notice: "Meta tag was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @meta_tag.update(meta_tag_params)
      redirect_to admin_meta_tags_path, notice: "Meta tag was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meta_tag.destroy
    redirect_to admin_meta_tags_path, notice: "Meta tag was successfully destroyed."
  end

  private
    def set_meta_tag
      @meta_tag = Current.admin_user.meta_tags.find(params[:id])
    end

    def meta_tag_params
      params.require(:meta_tag).permit(:title, :description, :page, :keywords)
    end
end
