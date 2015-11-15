#AccountsTemplates.configure
#  showForgotPasswordLink: true
#  overrideLoginErrors: true
#  enablePasswordChange: true
#  sendVerificationEmail: false
#
#  hideSignInLink: true
#  hideSignUpLink: true

if Meteor.isClient
  Accounts.onLogin ->
    redirect = Session.get "redirectAfterLogin"
    if redirect?
      unless redirect is '/login'
        delete Session.keys.redirectAfterLogin
        FlowRouter.go redirect