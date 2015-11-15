Template.bluePrintForm.onCreated ()->
  self = @
  self.autorun ()->
    self.subscribe 'singleEntry', FlowRouter.getParam('id')

Template.bluePrintForm.helpers
  'doc': ()->
    if FlowRouter.getParam('id')
      bluePrints.findOne()
  'formType': ()->
    if not FlowRouter.getParam('id')
      'insert'
    else
      'update'


hook =
  before:
    'update': (doc)->
      if not doc.lastUpdate
        doc.$set.lastUpdate = moment().format()
      else
        doc.lastUpdate = moment().format()

      doc
    'insert': (doc)->
      doc.pubDate = moment().format()
      doc.lastUpdate = moment().format()
      console.log doc
      doc
  onSuccess: (formType, result)->
    if formType == 'update'
      FlowRouter.go('/view/' + FlowRouter.getParam('id'))
    else
      FlowRouter.go('/view/' + result)

    GAnalytics.event("blueprint", "created")

  onError: (formType, error)->
    sAlert.error(error)


AutoForm.addHooks 'bluePrintForm', hook