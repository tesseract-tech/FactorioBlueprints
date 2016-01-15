
Tracker.autorun ()->
  if Meteor.user()? && !Meteor.user().username?
    BlazeLayout.render 'layout', {content: 'setUserName'}

Template.setUserName.events
  'submit form': (event, template)->
    event.preventDefault();
    username = template.find('#userName').value;

    template.find('#submitUsername').disabled=true

    usernameRegex = /^[a-zA-Z0-9]+$/;
    if username == ''
      sAlert.error('Username is required')
      return null

    if ! usernameRegex.test(username)
      sAlert.error('Invalid Username')
      return null

    Meteor.call 'updateUsername', username, (err)->
      if err
        sAlert.error(err.reason)

      FlowRouter.go('/')
