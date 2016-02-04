class Admins::PartnersController < Admins::BaseController
  def index
    @q = Partner.ransack(params[:q])
    @partners = @q.result(distinct: true)
    @partners = @partners.paginate(page: params[:page], per_page: Settings.pagination.partner_page_size)
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      redirect_to admins_partners_path, notice: '添加成功。'
    else
      flash.now[:error] = @partner.errors.full_messages.first
      render 'new'
    end
  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def update
    @partner = Partner.find(params[:id])
    if @partner.update(partner_params)
      redirect_to admins_partners_path, notice: '编辑成功。'
    else
      flash.now[:error] = @partner.errors.full_messages.first
      render 'edit'
    end
  end

  def destroy
    partner = Partner.find(params[:id])
    if partner.destroy
      redirect_to admins_partners_path, notice: '删除成功。'
    else
      redirect_to admins_partners_path, error: '程序异常，删除失败。'
    end
  end

  private
  def partner_params
    params.require(:partner).permit(:name, :logo, :url, :qrcode)
  end
end
