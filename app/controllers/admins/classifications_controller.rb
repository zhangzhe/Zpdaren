class Admins::ClassificationsController < Admins::BaseController

  def index
    @classifications = Classification.roots
  end

  def new
    @classification = Classification.new
  end

  def create
    @classification = Classification.new(classification_params)
    respond_to do |format|
      if @classification.save
        format.html { redirect_to admins_classifications_path, notice: '创建成功。' }
        format.js
      else
        format.html do
          flash.now[:error] = '程序异常，创建失败。'
          render :new
        end
        format.js
      end
    end
  end

  def edit
    @classification = Classification.find(params[:id])
  end

  def update
    @classification = Classification.find(params[:id])
    @classification.name = classification_params[:name]
    respond_to do |format|
      if @classification.save
        format.html { redirect_to admins_classifications_path, notice: '修改成功。' }
        format.js
      else
        format.html do
          flash.now[:error] = '程序异常，修改失败。'
          render :edit
        end
        format.js
      end
    end
  end

  def destroy
    classification = Classification.find(params[:id])
    if classification.destroy
      redirect_to admins_classifications_path, notice: '删除成功。'
    else
      redirect_to admins_classifications_path, error: '程序异常，删除失败。'
    end
  end

  private

  def classification_params
    params.require(:classification).permit(:parent_id, :name)
  end
end
