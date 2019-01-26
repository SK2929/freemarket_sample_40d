class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :confirm, :edit]
  before_action :set_item_category, only: [:show, :user_buy_screen, :pay_jp]

  def index

    @categories = Category.where(ancestry: nil)
    @items = Item.order("created_at DESC").page(params[:page]).per(12)

  end

  def new
    @item = Item.new
    @item.item_categories.build
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render action: :new
    end
  end

  def show

  end

  def edit
    @item = Item.find(params[:id])
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy if item.user_id == current_user.id
    redirect_to "/users/items_show"
  end

  def update
    item = Item.find(params[:id])
    if item.user_id == current_user.id
      item.update(item_params)
      redirect_to item_path
    end
  end

  def confirm
    #購入確認画面表示のためのアクション
  end

  def search
    @items = Item.where('name LIKE?', "%#{params[:search]}%")
  end

  def user_buy_screen

  end

  def create_customer_information
    customer = CustomersInformation.new
    create_customer = Payjp::Customer.create(
      email: current_user.email,
      card: params['payjp-token'])
    customer.update(customer: create_customer.id, user_id: current_user.id)
    pay_jp(create_customer)
  end

  def pay_jp(create_customer)
    item = Item.find(params[:id])
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      currency: "jpy",
      amount: item[:price],
      customer: create_customer.id)
    pay_jp_item_buyer_id_update(item)
    redirect_to root_path, notice: "支払いが完了しました"
  end

  def pay_jp_item_buyer_id_update(item)
    item.update(buyer_id: current_user.id)
  end

private

  def set_item_category
    @item = Item.find(params[:id])
    @item_category = ItemCategory.select('category_id').find_by(item_id: params[:id])
    @category = Category.find_by(id: @item_category.category_id)
  end

  def item_params
    params.require(:item).permit(:name, :description, :price, :image, :item_categories_attributes => [:id, :category_id]).merge(user_id: current_user.id)
  end

end
