module ConfigGui
  # input your ROMA's ip address or hostname
  HOST = "192.168.33.12"

  # input your ROMA's port No.
  PORT = "10001"

  # set your account infomation
  # [:username] and [:password] are set a limit by 30 characters.
  ROOT_USER = [
    ###{:username => 'input your username', :password => 'input passsword', :email => '[optional]gravatar's email address},
    {:username => 'hiroaki.iwase', :password => 'rakuten', :email => 'hiroaki.iwase.r@gmail.com' },
  ]

  NORMAL_USER = [
    ### NORMAL user are limited some functions.
    #{:username => '', :password => '', :email => '' },
  ]
end
