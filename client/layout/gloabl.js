document.write = function(content) {
  var src;
  if (document.currentScript) {
    src = document.currentScript.src.replace(/\#.*$/, '').replace(/\?.*$/, '').replace(/^.*\/\//, '');
    setTimeout((function() {
      var script;
      script = $('script').filter(function() {
        var scriptSrc;
        scriptSrc = $(this).attr('src');
        return scriptSrc && scriptSrc.indexOf(src) !== -1;
      });
      $('<div></div>').addClass('doc-write').html(content).insertAfter(script);
    }), 0);
  } else {
    HTMLDocument.prototype.write.apply(document, arguments);
  }
};
