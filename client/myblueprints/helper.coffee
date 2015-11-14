Template.myPrints.onCreated ()->
  this.counter = new ReactiveVar(0)

  userId = FlowRouter.getParam('id')

  if not FlowRouter.getParam('id')
    userId = Meteor.userId()

  self = @
  self.autorun ()->
    self.subscribe 'byUserId', userId

Template.myPrints.helpers
  'prints': ()->
    userId = FlowRouter.getParam('id')

    if not FlowRouter.getParam('id')
      userId = Meteor.userId()

    bluePrints.find(user: userId)

  'endOfRow': ()->
#     Exit if we are at the end of the docs
    if bluePrints.find().count() <= Template.instance().counter.get()
      return false

    value = Template.instance().counter.get();

    value++

    Template.instance().counter.set(value)

    if (value % 4 == 0) then true else false