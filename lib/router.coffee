FlowRouter.route '/',
  action: ()->
    BlazeLayout.render 'layout', {content: 'homePage'}

FlowRouter.route '/signup',
  action : ()->
    BlazeLayout.render 'layout', {content: 'signUp'}

FlowRouter.route '/create',
    action : ()->
      BlazeLayout.render 'layout', {content: 'createBluePrint'}


FlowRouter.route '/view/:id',
  action : (params)->
    BlazeLayout.render 'layout', {content: 'single'}