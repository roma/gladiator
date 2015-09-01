module ConfigGui
  # input your ROMA's ip address or hostname
  HOST = ""

  # input your ROMA's port No.
  PORT = ""

  # set your account infomation
  # [:username] and [:password] are set a limit by 30 characters.
  ROOT_USER = [
    ###{:username => 'input your username', :password => 'input passsword', :email => '[optional]gravatar's email address},
    #{:username => '', :password => '', :email => '' },
  ]

  NORMAL_USER = [
    ### NORMAL user are limited some functions.
    #{:username => '', :password => '', :email => '' },
  ]
end
