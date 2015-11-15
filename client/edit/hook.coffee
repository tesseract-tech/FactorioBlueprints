Template.editBluePrint.onCreated ()->
  id = FlowRouter.getParam("id");
  this.subscribe('singleEntry', id)


Template.editBluePrint.helpers
  'doc': ()->
    bluePrints.findOne()


hook =
  after:
    insert: (error, result)->

  onSuccess: (formType, result)->
    FlowRouter.go('/view/' + result)
  onError: (formType, error)->
    console.log error


AutoForm.addHooks 'editBluePrint', hook