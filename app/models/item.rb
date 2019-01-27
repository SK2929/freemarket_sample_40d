class Item < ApplicationRecord
  belongs_to :user
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories

  validates :name, presence: true, length: { maximum: 40 }      # 「40文字以下」
  validates :description, presence: true, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 300 }
  validates :image, presence: true
  mount_uploader :image, ImageUploader
  accepts_nested_attributes_for :item_categories

# show_error_message_imageメソッド（画像送信）において適切なバリデーションが出るように後で編集すること
  def show_error_message_image(item_image)
    if item_image == nil
      "不備があります"
    else
      ""
    end
  end

  def show_error_message_item(item_name)
    if item_name.length == 0
      "入力してください"
    elsif item_name.length > 40
      "40文字以下で入力してください"
    else
      ""
    end
  end

  def show_error_message_idescription(item_idescription)
    if item_idescription.length == 0
      "入力してください"
    elsif item_idescription.length > 1000
      "1000文字以下で入力してください"
    else
      ""
    end
  end

  def show_error_message_price(item_price)
    if (item_price.length == 0) || (item_price.to_i > 299) == false
      "300以上9999999以下で入力してください"
    else
      ""
    end
  end
end
