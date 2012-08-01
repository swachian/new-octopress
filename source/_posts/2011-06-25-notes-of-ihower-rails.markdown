---
layout: post
title: "ihower rails的学习记录"
date: 2011-06-25 18:48
comments: true
categories: 
- 技术
- 读书笔记
---
HTML use syntax: true

Rails 命令

    rails s(erver) thin
    rails new app
    rails g(enerate) model/controller/resouce/migration
    rails dbconsole #打开数据库的console
    rails destroy #和generate对应


一些启动参数，位于application 和各目录下面

    config.cache_classes = false 对应load
    config.cache_classes = true 对应require
    #其实挺简单的东西，当你了解语言特性的话
    config.action_mailer.perform_deliveries = false 是否会寄信


路由

    match '/events', :to => "events#index", :via => :get, :as => "events"
    match '/events', :to => "events#create", :via => :post, :as => "events"
    #增加 :as可以提供events_path这样的helper


action_name cookies header params session 等在controllers中都是方法

几种controller内的render

    * render :text => "Hello" 直接回傳字串內容，不使用任何樣板。
    * render :xml => @event.to_xml 回傳XML格式
    * render :json => @event.to_json 回傳JSON格式(再加上:callback就會是JSONP)
    * render :nothing => true 空空如也

    * :template 指定Template
    * :action 指定使用該Action的Template(注意到只是使用它的Template，而不會執行該Action內的程式)
    * :file 指定Template的檔名全名

    #其他参数
    * :status 設定HTTP status，預設是200，也就是正常。其他常用代碼包括401權限不足、404找不到頁面、500伺服器錯誤等。
    * :layout 可以指定這個Action的Layout，設成false即關掉Layout
render_to_string :partial => "foobar"
    * redirect_to :action => "show", :id => @event
    * redirect_to :back 回到上一頁。
</pre>

flash的新老写法
<pre>
flash[:notice]
flash.now[:notice]
</pre>

rescue_from可以在Controller中宣告救回例外, :show_found是对应的例外执行方法
<pre>
resuce_from ActiveRecord::RecordNotFound, :wtih => :show_found
</pre>

###ActiveRecord中的多对多关联

這個Join table筆者的命名習慣會是ship結尾，用以凸顯它的關聯性質。另外，除了定義Foreign Keys之外，你也可以自由定義一些額外的欄位，例如記錄是哪位使用者建立關聯。

has_and_belongs_to_many方法也可以建立多對多關係，但已很少使用
<pre>
has_many  ：models ，:through =>model_ships用的更多
ModelShip.create(:m1=>m1, :m2=>m2)很有意思
</pre>

自定义validate方法，注意礼貌的错误添加手法
<pre>
validate :my_validation

private

def my_validation
    if name =~ /foo/
        errors[:name] << "can not be foo"
    elsif name =~ /bar/
        errors[:name] << "can not be bar"
    elsif name == 'xxx'
        errors[:base] << "can not be xxx"
      end
end
</pre>

可以在before_validation中要求增加缺省值，改回调在before_save前
<pre>
before_validation :setup_default
</pre>
請避免before_開頭的回呼方法中，最後運算的結果不小心回傳false。這樣會中斷儲存程序。如果不確定的話，請回傳return true。
而在其他回调方法中，是不是false则无所谓

新老数据的获取及比对
<pre>
person.changed?       # => true 有改變
person.name_changed?  # => true 這個屬性有改變
person.name_was       # => 'Uncle Bob' 改變之前的值
person.name_change    # => ['Uncle Bob', 'Bob']
</pre>

### layout及ActionView

使用字串和symbol效果不同，前者直接定义模板名称，后者表明执行一个函数
<pre>
layout "special", :except => [:show, :edit, :new]
layout :determine_layout
</pre>


因為Helper預設只能在Template中使用，如果想在rails console中呼叫，必須加上helper，例如<pre>helper.link_to</pre>。另外，雖然機會不多，如果真的要在Rails Controller或Model程式中呼叫Helper，則可以加上ApplicationController.helpers前置詞。

格式化輔助方法
<pre>
    * javascript_include_tag
    * stylesheet_link_tag
    * image_tag
    * video_tag
    * audio_tag
</pre>
video_*和audio_*是新增加的

几个文本处理方法，textilize被移出3.0
<pre>
    * simple_format 將\n換行字元換成HTML的<br>標籤
    * truncate 擷取前n個字元
    * sanitize 白名單逸出
    * strip_tags 移除HTML標籤
    * strip_links 移除HTML超連結標籤
</pre>

URL輔助方法
<pre>
    * link_to 文字超連結
    * mail_to E-mail
    * button_to 按鈕連結
</pre>

自定標籤輔助方法 ?

    * tag
    * content_tag

其他輔助方法
<pre>
    * escape_javascript
    * debug
    * number_to_currency
</pre>

在Rails 2版本中有error_messages_for和error_message_on方法，Rails 3則被移成Plugin http://github.com/rails/dynamic_form，实际上用ryan的直接写在application_helper中也行

如果採用Sass的話，推薦還可以採用Compass(http://compass-style.org/)這套CSS框架的框架。


生产环境下，还是需要rake assets:precompile来在public/assets目录下产生css文件
<pre>
rake assets:precompile #要求pipeline产生文件
</pre>

3种新的远程(ajax)调用写法
<pre>
<%=link_to “say hello”, { :controller => “welcome”, :action => “say” }, :id => “ajax-load”, :remote => true, “data-type” => “html”%> #替换整个html，相当于replace_html情形
</pre>
<pre>
#执行js脚本
<%= link_to 'ajax show', event_path(event), :remote => true, "data-type" => "script" %>
js.erb
$('#content').html("<%= escape_javascript(render :partial => 'event') %>")
             .css({ backgroundColor: '#ffff99' });
</pre>

<pre>
#返回json对象
<%= link_to 'ajax show', event_path(event), :remote => true, "data-type" => "json" %>
</pre>

i18n的中文素材文件
https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale/
資料庫裡面的時間一定都是儲存 UTC 時間?

避免category是nil时报出异常的优良写法
<pre>
Event里面
delegate :name, :to => :category, :prefix => true, :allow_nil => true
@event.category_name
</pre>

产生带namespace的resources
<pre>
rails g controller admin::events
</pre>

rspec测试的高手写法
<pre>
describe Order do
  subject { Order.new(:status=>"New")}
  it(:status) {should == "new" }
end
</pre>
