hook =
  after:
    insert: (error, result)->

  onSuccess: (formType, result)->
    GAnalytics.event("blueprint","created")
    FlowRouter.go('/view/' + result)
  onError: (formType, error)->
    console.log error


AutoForm.addHooks 'insertBluePrint', hook