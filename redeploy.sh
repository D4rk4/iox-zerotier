APP_NAME=ZeroTier
ioxclient application stop $APP_NAME
ioxclient application deactivate $APP_NAME
ioxclient application upgrade $APP_NAME ./zerotier.tar
ioxclient application activate --payload activate.json $APP_NAME
ioxclient application start $APP_NAME
