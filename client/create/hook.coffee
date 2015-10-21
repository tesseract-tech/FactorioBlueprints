hook =
  after:
    insert: (error, result)->

  onSuccess: (formType, result)->
    FlowRouter.go('/view/' + result)
  onError: (formType, error)->
    console.log error


AutoForm.addHooks 'insertBluePrint', hook