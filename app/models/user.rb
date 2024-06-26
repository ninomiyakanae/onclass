class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  # has_many :applied_attendances, class_name: 'Attendance', foreign_key: 'applied_user_id'
  # accepts_nested_attributes_for :attendances
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :affiliation, length: { in: 2..50 }, allow_blank: true
  # validates :employee_number, presence: true, uniqueness: true
  # validates :employee_number, presence: true, allow_blank: true
  validates :basic_work_time, presence: true
  validates :work_time, presence: true
  # validates :designated_work_start_time
  # validates :designated_work_end_time
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end
  
   def self.search(search) #self.はUser.を意味する
     if search
      @users = User.where(['name LIKE ?', "%#{search}%"]) #検索とuseanameの部分一致を表示。
     else
       User.all #全て表示させる
     end   
   end   
   
  def self.import(file)
    failed_emails = []
  
    CSV.foreach(file.path, headers: true) do |row|
      existing_user = User.find_by(email: row["email"])
      
      if existing_user
        failed_emails << row['email']
      else
        user = User.new
        user.attributes = row.to_hash.slice(*["name", "email", "affiliation", "employee_number", "uid", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"])
        user.save!
      end
    end
    
    failed_emails
  end
end




