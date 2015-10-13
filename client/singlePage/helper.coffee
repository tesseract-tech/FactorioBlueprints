Template.single.onCreated ()->
  console.log FlowRouter.getParam('id')
  this.subscribe('singleEntry', FlowRouter.getParam('id'))
  this.subscribe('favorites')

Template.single.helpers
  'doc': ()->
    bluePrints.findOne({_id: FlowRouter.getParam('id')})


Template.single.onRendered ()->
  client = new ZeroClipboard(document.getElementById('bluePrintBtn'))

  client.on 'ready', (readyEvent)->
    client.on 'aftercopy', (event)->
      sAlert.success('Copied')
      event.target.classList.add('btn-success')
      event.target.innerHTML = 'Copied to Clipboard'
