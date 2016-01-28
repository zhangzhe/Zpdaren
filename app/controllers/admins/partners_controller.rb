class Admins::PartnersController < Admins::BaseController
  def index
    @q = Partner.ransack(params[:q])
    @partners = @q.result(distinct: true)
    @partners = @partners.paginate(page: params[:page], per_page: Settings.pagination.page_size)
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
      render 'new' and return
    end
  end

  def show
    @partner = Partner.find(params[:id])
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
      render 'edit' and return
    end
  end

  def destroy
    partner = Partner.find(params[:id])
    if partner.destroy
      redirect_to admins_partners_path, notice: '删除成功。'
    else
      flash.now[:error] = '程序异常，删除失败。'
      redirect_to admins_partners_path
    end
  end

  def logo_download
    partner = Partner.find(params[:id])
    send_file partner.logo.current_path
  end

  private
  def partner_params
    params[:partner].permit!
  end
end
