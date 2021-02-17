class PrototypesController < ApplicationController
  before_action :prototype_user, only: [:edit, :show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :move_to_index, except: [:index, :show]
  before_action :cheak_user, only: [:edit]
  before_action :search_product, only: [:index]

  def index
    @prototype = Prototype.includes(:user)
    @results = @p.result.includes(:user).order("created_at DESC")
    set_product_column
  
  end
  def new
    @prototype = Prototype.new
  end
  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save!
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end
  
  def update
     @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
   if @prototype.destroy
     redirect_to root_path
   else
     redirect_to root_path
  end
 end
  



  private
  def prototype_params 
    params.require(:prototype).permit(:title, :catch_copy,:concept,:image).merge(user_id: current_user.id)
  end
  def move_to_index
    unless  user_signed_in?
      redirect_to action: :index
    end
  end

  
  def cheak_user
    unless  current_user == @prototype.user
      redirect_to action: :index
    end
  end

def prototype_user
  @prototype = Prototype.find(params[:id])
 end

 def search_product
  @p = Prototype.ransack(params[:q])  # 検索オブジェクトを生成
end

def set_product_column
  @product_name = Prototype.select("catch_copy").distinct  # 重複なくnameカラムのデータを取り出す
end

end
