module LoginMacros
  def login_as(user)
    visit admin_login_identifier
    fill_in 'user[name]',	with: user.name
    click_button '次へ'
    fill_in 'user[password]',	with: 'password'
    click_button 'ログイン'
  end