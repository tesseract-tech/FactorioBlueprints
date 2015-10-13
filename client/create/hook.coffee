hook =
  after:
    insert:(error, result)->
      console.log error
      console.log result

  onSuccess: ()->
    console.log "yay"
  onError: (formType, error)->
    console.log error


AutoForm.addHooks 'insertBluePrint', hook