# set page limit
@pageLimit = 8

Meteor.startup ()->
  sAlert.config
    effect: 'jelly'
    position: 'bottom'
    stack: true
    beep: true

  Accounts.ui.config
    passwordSignupFields: 'USERNAME_AND_OPTIONAL_EMAIL'