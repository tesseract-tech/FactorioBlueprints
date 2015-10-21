Meteor.startup ()->
  sAlert.config
    effect: 'jelly'
    position: 'bottom-right'
    stack: true
    beep: true

  Accounts.ui.config
    passwordSignupFields: 'USERNAME_AND_OPTIONAL_EMAIL'