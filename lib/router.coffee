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


#404 page
FlowRouter.notFound =
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'page404'}
