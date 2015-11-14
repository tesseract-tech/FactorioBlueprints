FlowRouter.route '/',
  action: ()->
    BlazeLayout.render 'layout', {content: 'homePage'}

FlowRouter.route '/signup',
  action: ()->
    BlazeLayout.render 'layout', {content: 'signUp'}

FlowRouter.route '/create',
  action: ()->
    BlazeLayout.render 'layout', {content: 'createBluePrint'}


FlowRouter.route '/view/:id',
  action: (params)->
    BlazeLayout.render 'layout', {content: 'single'}

FlowRouter.route '/edit/:id',
  action: (params)->
    BlazeLayout.render 'layout', {content: 'editBluePrint'}

FlowRouter.route '/user/bluePrints',
  action: ()->
    BlazeLayout.render 'layout', {content: 'myPrints'}


#404 page
FlowRouter.notFound =
  action: ()->
    BlazeLayout.render 'layout', {content: 'page404'}
