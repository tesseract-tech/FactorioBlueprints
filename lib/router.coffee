trackPage = (context, redirect, dostop)->
  route = FlowRouter.current()
  Session.set('redirectAfterLogin', route.path)

validateLogin = (context, redirect, doStop)->
  unless Meteor.loggingIn() or Meteor.userId()
    Template._loginButtons.toggleDropdown()
    sAlert.error('You must be logged in.')
    if context.oldRoute?
      redirect(context.oldRoute.path)
    else
      redirect('/')

# This will make sure you cant go to any pages wihtout haveing a username
checkUserName = (context, redirect, doStop)->
  if Meteor.user() && !Meteor.user().username?
    BlazeLayout.render 'layout', {content: 'setUserName'}
    doStop()

## Global triggers

FlowRouter.triggers.enter([checkUserName])
FlowRouter.triggers.exit([checkUserName])


FlowRouter.route '/',
  action: ()->
    GAnalytics.pageview("/");
    BlazeLayout.render 'layout', {content: 'homePage'}


FlowRouter.route '/create',
  triggersEnter: [trackPage, validateLogin]
  action: ()->
    BlazeLayout.render 'layout', {content: 'bluePrintForm'}


FlowRouter.route '/view/:id',
  action: (params)->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'single'}

FlowRouter.route '/edit/:id',
  triggersEnter: [trackPage, validateLogin]
  action: (params)->
    BlazeLayout.render 'layout', {content: 'bluePrintForm'}

FlowRouter.route '/user/bluePrints',
  triggersEnter: [trackPage, validateLogin]
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'myPrints'}

FlowRouter.route '/user/favs',
  triggersEnter: [trackPage, validateLogin]
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'myFavs'}

FlowRouter.route '/bluePrints',
  action: ()->
    GAnalytics.pageview()
    BlazeLayout.render 'layout', {content: 'bluePrints'}

FlowRouter.route '/user/:username',
  triggers: [trackPage]
  action: (params)->
    BlazeLayout.render 'layout', {content: 'postByUser'}


#404 page
FlowRouter.notFound =
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'page404'}
