class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :admin_or_correct_user, only: :show
  
  
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    # respond_to do |format|
    #   format.html # HTML形式のレスポンスを処理
    #   format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" } # CSV形式のレスポンスを処理
  end
    # @user = current_user # これがログイン中のユーザーを取得するメソッドであれば

  # def index
  #   @users = User.where.not(id: 1).paginate(page: params[:page]).search(params[:search])
  #   # @users = User.all
  # end
  
  # def import
  #   file = params[:file]
  #   if file.nil?
  #     flash[:danger] = "ファイルが選択されていません"
  #     redirect_to users_url and return
  #   end
  #   User.import(file)
  #   flash[:success] = "データのインポートに成功しました"
  #   redirect_to users_url
  # end
  
  def import
    failed_emails = User.import(params[:file])
  
    if failed_emails.empty?
      flash[:success] = 'インポートに成功しました。'
    else
      flash[:danger] = "メールアドレス #{failed_emails.join(', ')} はすでに存在します。"
    end
    
    redirect_to users_path
  end

  def show
    @worked_sum = @attendances.where.not(designated_work_start_time: nil).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  # def import
  #   if params[:file].blank?
  #     flash[:danger] = "csvファイルを選択してください"
  #   else
  #     User.import(params[:file])
  #     flash[:success] = "csvファイルをインポートしました。"
  #   end
  #   redirect_to users_url
  # end
  
  # def import
  #   # fileはtmpに自動で一時保存される
  #   User.import(params[:file])
  #   redirect_to users_url
  # end  
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
end
