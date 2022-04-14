/*
 * Script for the main frame.
 * An adaptation of (darkfish.js by Michael Granger)
 */

function setupShowSource() {
  //$('.method-detail').click(showSource);
  $('.method-heading').click(toggleSource);
};

function toggleSource(e) {
  //TODO not when clicking a link
  $(e.target).parents('.method-detail').find('.method-source-code').slideToggle();
};

function setupShowConstantValue() {
  $('#constant-list .const-display').click(toggleValue);
};

function toggleValue(e) {
  //TODO not when clicking a link
  $(this).next().toggle();
};

function setupShowAllFiles() {
  var allFiles = $('#all-files');
  if (allFiles.length == 0) return;
  var skipBodyClick = false;
  $('#show-all-files').click(function(e) {
    e.preventDefault();
    skipBodyClick = true;
    if (allFiles.css('display') == 'block')
      allFiles.css('display', 'none');
    else
      allFiles.css('display', 'block');
  });
  $('body').click(function() {
    if (skipBodyClick)
      skipBodyClick = false;
    else if (allFiles.css('display') == 'block')
      allFiles.css('display', 'none');
  });
}

function setupResizing() {

  var doc = $('#documentation');
  var delta = $('body').outerHeight() - doc.height();

  // callback on resize event
  $(window).resize(function() {
    frameResized(doc, delta);
  });

  // initial resize
  frameResized(doc, delta);
}

function frameResized(doc, delta) {
  var frameHeight = $(window).height();
  if ($.browser.mozilla) frameHeight--;
  newHeight = frameHeight - delta;
  //console.debug('frameHeight: %s', frameHeight);
  //console.debug('delta: %s', delta);
  //console.debug('newHeight: %s', newHeight);
  if (newHeight > 50)
    doc.height(newHeight);
}

function highlightUrlHash() {
  //console.debug('window.location.href: %s', window.location.href);
  var h = window.location.hash;
  if (h && h != '') {
    highlightElement(h);
  }
};

function highlightTarget(e) {
  var href = $(e.target).attr('href');
  //console.debug('Highlighting link href=%s', href);
  var match =/(#.*)/.exec(href);
  if (match && match[1].length > 1) {
    highlightElement(match[1]);
  }
};

function highlightElement(id) {
  //console.debug('Highlighting %s.', id);
  $('.highlighted').removeClass('highlighted');
  var e = $(id);
  if (e.length > 0) {
    e.addClass('highlighted');
    //console.debug('added class "highlighted" to %s.', id);
  }
  else {
    //console.debug('not found: %s', id);
  }
};

$(document).ready( function() {
  setupShowSource();
  setupShowConstantValue();
  setupShowAllFiles();
  //setupResizing();  interferes with hyperlinking
  highlightUrlHash();
  $('a[href*="#"]').click(highlightTarget);
});
