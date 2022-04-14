
// returns the info about an index block
// index blocks are like this:
//  div
//    .title
//      span
//      input
//    .entries
//      p ...
function indexElements(type) {
  var id = '#' + type + '-index';
  var block = $(id);
  if (block.length > 0)
    return {
      div: block,
      fullHeight: block.height(),
      title: $(id + ' > .title'),
      searchBox: $(id + ' > .title input'),
      list: $(id + ' > .entries'),
      entries: $(id + ' > .entries > p')
    };
  else
    return {
      div: block,
      fullHeight: 0,
      title: block,
      searchBox: block,
      list: block,
      entries: block
    };
}

// handle highlighting in main frame when the document
// in the main frame does not change
function highlightTarget(e) {
  // this is relative:
  var target_href = $(e.target).attr('href');
  // this is absolute:
  var current_href = top.mainFrame.location.href;
  //console.debug('left: target href=%s', target_href);
  //console.debug('left: current href=%s', current_href);
  var parts = target_href.split('#');
  var target_path = parts[0], target_id = '#' + parts[1];
  var current_path = top.mainFrame.location.pathname;
  //console.debug('left: target path=%s', target_path);
  //console.debug('left: current path=%s', current_path);
  var i = current_path.length - target_path.length;
  var x = current_path.substring(i);
  if (i > 0 && current_path.substring(i) == target_path) {
    highlightElement(target_id);
  }
}

// highlight the passed id in the main frame
function highlightElement(id) {
  //console.debug('Highlighting %s in main frame.', id);
  var context = top.mainFrame.document;
  $('.highlighted', context).removeClass('highlighted');
  var e = $(id, context);
  if (e.length > 0) {
    e.addClass('highlighted');
    //console.debug('added class "highlighted" to %s.', id);
  }
  else {
    //console.debug('not found: %s', id);
  }
};

function setupHighlighting (methodList) {
  methodList.find('a[href*="#method-"]').click(highlightTarget);
}

// setup search boxes
function setupSearches(classIndex, methodIndex) {
  var helpText = 'filter...';
  setupSearch(classIndex.searchBox, classIndex.entries, helpText);
  setupSearch(methodIndex.searchBox, methodIndex.entries, helpText);
}

function setupSearch(searchBox, entries, helpText) {
  // hook quicksearch
  searchBox.quicksearch(entries);
  // set helper text
  searchBox[0].value = helpText;
  searchBox.focus(function() {
    if (this.value == helpText) {
      this.value = '';
      $(this).addClass('active');
    }
  });
  searchBox.blur(function() {
    if (this.value == '') {
      this.value = helpText;
      $(this).removeClass('active');
    }
  });
}

// setup callbacks resizing vertically & horizontally;
function setupResizing(classIndex, methodIndex) {

  // height of one entry
  var entryHeight = classIndex.list.height() / classIndex.entries.length;

  // amount of vertical space in an index other than the entries themselves
  // (title, paddings, etc.)
  var delta = classIndex.fullHeight - classIndex.list.height();

  //console.debug('entryHeight = %s', entryHeight);
  //console.debug('delta = %s', delta);

  // reference information for resize
  var resizeInfo = {
    fileIndex: indexElements('file'),
    classIndex: classIndex,
    methodIndex: methodIndex,
    entryHeight: entryHeight,
    fullBoxWidth: classIndex.searchBox.width(),
    delta: delta
  };

  //console.debug('fileIndex.fullHeight = %s', resizeInfo.fileIndex.fullHeight);
  //console.debug('classIndex.fullHeight = %s', resizeInfo.classIndex.fullHeight);
  //console.debug('methodIndex.fullHeight = %s', resizeInfo.methodIndex.fullHeight);

  // callback on resize event
  $(window).resize(function() {
    frameResized(resizeInfo);
  });

  // initial resize
  frameResized(resizeInfo);
}

// smart resize of left index blocks
function frameResized(info) {
  //console.debug('resize fired');
  //console.debug('=== updating widths ===');
  resizeSearchField(info.classIndex, info.fullBoxWidth);
  resizeSearchField(info.methodIndex, info.fullBoxWidth);
  //console.debug('=== updating heights ===');
  var heights = updatedHeights(info);
  //console.debug('new file height = %s', heights.files);
  //console.debug('new class height = %s', heights.classes);
  //console.debug('new method height = %s', heights.methods);
  var delta = info.delta - 5;
  var speed = info.slideSpeed;
  // info.fileIndex.list.height(heights.files - delta, speed);
  info.classIndex.list.height(heights.classes - delta, speed);
  info.methodIndex.list.height(heights.methods - delta, speed);
  //console.debug('=== resizing done ===');
}

// resize a search field to avoid overlapping text (if possible)
function resizeSearchField(indexBlock, fullBoxWidth) {
  //console.debug('resizing search field for %s', indexBlock.title.text());
  var container = indexBlock.title,
      box = indexBlock.searchBox;
  var text = container.find('.text');

  var frameWidth = $(top.indexFrame).width();
  //console.debug('frameWidth = %s', frameWidth);

  var textWidth = text.width();
  var textRight = text.position().left + textWidth;
  //console.debug('text: width = %s, right = %s', textWidth, textRight);

  var boxLeft = box.position().left;
  var boxWidth = box.width();
  //console.debug('box: left = %s, width = %s', boxLeft, boxWidth);

  var boxRight = boxLeft + boxWidth;
  var offset = frameWidth - boxRight;
  //console.debug('box: right = %s, offset = %s', boxRight, offset);

  // try to ensure offset between the text & the box
  // if the box becomes too narrow, stop resizing it

  var boxSpace = frameWidth - 2 * offset - textRight;
  //console.debug('available space: %s', boxSpace);

  if (boxSpace >= fullBoxWidth) {
    //console.debug('full width: %s', fullBoxWidth);
    box.width(fullBoxWidth);   // plenty of room
  }
  else if (boxSpace > textWidth) {
    //console.debug('shrink to: %s', boxSpace);
    box.width(boxSpace);       // shrink it
  }
  else {
    //console.debug('min width: %s', textWidth);
    box.width(textWidth);      // min width
  }

}

// returns the updated heights of index blocks for the current window size
function updatedHeights(info) {

  var fileIndex = info.fileIndex,
      classIndex = info.classIndex,
      methodIndex = info.methodIndex,
      entryHeight = info.entryHeight;

  // returned information
  var heights = {
    files: fileIndex.fullHeight,
    classes: classIndex.fullHeight,
    methods: methodIndex.fullHeight
  };

  var frameHeight = $(window).height();
  if ($.browser.mozilla) frameHeight--;
  var totalHeight = heights.files + heights.classes + heights.methods;

  //console.debug('frameHeight = %s', frameHeight);
  //console.debug('totalHeight = %s', totalHeight);

  // if everything fits, we're done
  if (totalHeight <= frameHeight) {
    //console.debug('everything fits');
    return heights;
  }

  var excess = totalHeight - frameHeight;
  //console.debug('%s to gain', excess);

  // first try to reduce the file index
  if (fileIndex.entries.length > 5) {
    // the most we can gain:
    var gain = (fileIndex.entries.length - 5) * entryHeight;
    if (gain >= excess) {
      //console.debug('shrink files by %s, the rest fits', excess);
      // just shrinking the files will be fine
      heights.files -= excess;
      return heights;
    }
    // we will shrink something else: minimize the height for files
    heights.files -= gain;
    excess -= gain;
    //console.debug('shrink files to the max, still %s to gain', excess);
  }
  else {
    //console.debug('only %s files, cannot shrink them', fileIndex.entries.length);
  }

  // if the method list is more than 33% high,
  // try first to reduce it to 33%

  var maxHeight = Math.floor(frameHeight / 3);
  if (methodIndex.entries.length > 5) {
    if (methodIndex.fullHeight > maxHeight) {
      var gain = methodIndex.fullHeight - maxHeight;
      var maxGain = (methodIndex.entries.length - 5) * entryHeight;
      if (gain > maxGain) {
        //console.debug('limit of 5 methods reached, so gain will be %s instead of %s', maxGain, gain);
        gain = maxGain;
      }
      if (gain >= excess) {
        //console.debug('shrink methods by %s, classes fit', excess);
        // just shrinking the methods will be fine
        heights.methods -= excess;
        return heights;
      }
      // we will also shrink the classes: gain what we can
      heights.methods -= gain;
      excess -= gain;
      //console.debug('shrink methods by %s, still %s to gain', gain, excess);
    }
    else {
      //console.debug('methods <= 50%, not shrinked');
    }
  }
  else {
    //console.debug('only %s methods, cannot shrink them', methodIndex.entries.length);
  }

  // shrink the classes if possible
  if (classIndex.entries.length > 5) {
    var gain = excess;
    var maxGain = (classIndex.entries.length - 5) * entryHeight;
    if (gain > maxGain) {
      //console.debug('limit of 5 classes reached, so gain will be %s instead of %s', maxGain, gain);
      gain = maxGain;
    }
    heights.classes -= gain;
    excess -= gain;
    //console.debug('shrink classes by %s', gain);
  }
  else {
    //console.debug('only %s classes, cannot shrink them', classIndex.entries.length);
  }

  if (excess > 0) {
    //console.debug('minimal heights, excess = %', excess);
  }

  return heights;

}

$(document).ready(function() {

  // class index is used as reference, as there is always at least one class
  var classIndex = indexElements('class');
  var methodIndex = indexElements('method');

  setupResizing(classIndex, methodIndex);
  setupSearches(classIndex, methodIndex);
  setupHighlighting(methodIndex.list);

});

