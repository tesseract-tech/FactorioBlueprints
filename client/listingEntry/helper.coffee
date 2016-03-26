convertToJpg = (string)->
  urlparts = string.split('.')
  urlparts[urlparts.length - 1] = 'jpg'
  return urlparts.join('.')


Template.listingEntry.helpers
  'url': ()->
    FlowRouter.path "/view/:id", id: this._id
  image: ()->
    image = @.image

    newUrl = image.split('upload/')
    newUrl[1] = convertToJpg(newUrl[1])
    newUrl.join('upload/c_fill,g_center,h_260,r_0,w_460,q_60/')

  shortTags: ()->
    newList = []
    _.each @tags, (tag, index)->
      if index < 3
        newList.push(tag)
      else
        return;
    newList
