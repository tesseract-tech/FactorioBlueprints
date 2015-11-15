Template.listingEntry.helpers
  'url': ()->
    FlowRouter.path "/view/:id", id: this._id