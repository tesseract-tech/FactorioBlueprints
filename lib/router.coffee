FlowRouter.route '/',
  action: ()->
    GAnalytics.pageview("/");
    BlazeLayout.render 'layout', {content: 'homePage'}

FlowRouter.route '/signup',
  action: ()->
    BlazeLayout.render 'layout', {content: 'signUp'}

FlowRouter.route '/create',
  triggersEnter: [
    (context, redirect)->
      unless Meteor.loggingIn() or Meteor.userId()
        route = FlowRouter.current()
        unless route.route.name is '/login'
          Session.set 'redirectAfterLogin', route.path
        redirect('/login')
  ]
  action: ()->
    BlazeLayout.render 'layout', {content: 'createBluePrint'}


FlowRouter.route '/view/:id',
  action: (params)->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'single'}

FlowRouter.route '/edit/:id',
  action: (params)->
    BlazeLayout.render 'layout', {content: 'editBluePrint'}

FlowRouter.route '/user/bluePrints',
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'myPrints'}

FlowRouter.route '/user/favs',
  triggersEnter: [
    (context, redirect)->
      unless Meteor.loggingIn() or Meteor.userId()
        route = FlowRouter.current()
        unless route.route.name is '/login'
          Session.set 'redirectAfterLogin', route.path
        redirect('/login')
  ]
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'myFavs'}


FlowRouter.route '/login',
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'login'}

#404 page
FlowRouter.notFound =
  action: ()->
    GAnalytics.pageview();
    BlazeLayout.render 'layout', {content: 'page404'}
