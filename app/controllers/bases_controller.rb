class BasesController < ApplicationController
before_action :logged_in_user, only: [:destroy]
 
  def new
    @base = Base.new
  end
  
  def create
    @bases = Base.create(base_params)
     if @bases.save#  if文の条件式部分でuser.saveとすることで、データベースへの保存処理とその結果による条件分岐を行っています。
                   #  生成したモデルオブジェクトをデータベースに保存
      flash[:success] = "拠点情報の作成に成功しました。"
                                               #   何か処理を行なった時に、”正しく処理が行われましたよ”という情報を表示させるrailsの機能がflashメッセージ
                                               #   Railsの一般的な慣習に倣って、:successというキーには成功時のメッセージを代入するようにします 
      redirect_to bases_url                    #   指定したURLに遷移させることができるメソッドです
     else                                      # すべての条件式が「偽」だった場合、 else から end までの処理を実行します。
      render :new                              #   表示させるviewファイルを指定して表示
     end
  end
  
  def index
    @bases = Base.all                          # allメソッドとは、配列の全ての要素を取り出すメソッドです。
  end
   
  def show
    @bases = Bases.all
    # @base = Base.find(params[:id])
  end

  def edit
    @base = Base.find(params[:id])
  end

  def update
      @base = Base.find(params[:id])
    if @base.update_attributes(base_params) # Hashを引数に渡してデータベースのレコードを複数同時に更新することができるメソッドです。
      flash[:success] = "拠点情報を更新しました。"
                                         #   何か処理を行なった時に、”正しく処理が行われましたよ”という情報を表示させるrailsの機能がflashメッセージ
                                         #   Railsの一般的な慣習に倣って、:successというキーには成功時のメッセージを代入するようにします 
      redirect_to bases_url              #   指定したURLに遷移させることができるメソッドです
    else                                 # すべての条件式が「偽」だった場合、 else から end までの処理を実行します。
      render :edit                       #   表示させるviewファイルを指定して表示
    end
  end  
  
   def destroy
    @base = Base.find(params[:id])
     @base.destroy
     flash[:success] = "拠点情報を削除しました。"
                                         #   何か処理を行なった時に、”正しく処理が行われましたよ”という情報を表示させるrailsの機能がflashメッセージ
                                         #   Railsの一般的な慣習に倣って、:successというキーには成功時のメッセージを代入するようにします 
     redirect_to bases_url               #   指定したURLに遷移させることができるメソッドです
   end
 
  private
#   クラスの外からは呼び出せない。同じインスタンス内でのみ、関数形式で呼び出せる。
  
  def base_params
     params.require(:base).permit(:base_number, :base_name, :work_type )
  end
# .requireメソッドがデータのオブジェクト名を定め、
# .permitメソッドで変更を加えられる（保存の処理ができる）キーを指定します。

# これをあらかじめ設定しておくことで、
# 仮に悪意のあるリクエスト（指定した以外のデータを送ってくる等）を受けた際に、
# .permitメソッドで許可していない項目については変更されず、データの扱いがより安全になります。

end