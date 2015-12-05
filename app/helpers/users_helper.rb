module UsersHelper
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    # メールアドレスからGravatarの画像用URLを生成し、gravatar_urlに代入
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    # <img>タグを出力
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
