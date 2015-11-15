Template.listingEntry.helpers
  'url': ()->
    FlowRouter.path "/view/:id", id: this._id
  image: ()->
    image = @.image

    newUrl = image.split('upload/')
    newUrl.join('upload/c_fill,g_center,h_260,r_0,w_460/')