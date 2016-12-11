---
layout: page
title: Brat example page
subtitle: This page is just a test now
---


<div id="main" class="center">
<div id="content">

<div id="embedding-entity-example"></div>

<script type="text/javascript">
var bratLocation = 'http://weaver.nlplab.org/~brat/demo/v1.3';
head.js(
// External libraries
bratLocation + '/client/lib/jquery.min.js',
bratLocation + '/client/lib/jquery.svg.min.js',
bratLocation + '/client/lib/jquery.svgdom.min.js',


// brat helper modules
bratLocation + '/client/src/configuration.js',
bratLocation + '/client/src/util.js',
bratLocation + '/client/src/annotation_log.js',
bratLocation + '/client/lib/webfont.js',
// brat modules
bratLocation + '/client/src/dispatcher.js',
bratLocation + '/client/src/url_monitor.js',
bratLocation + '/client/src/visualizer.js'
);

var webFontURLs = [
bratLocation + '/static/fonts/Astloch-Bold.ttf',
bratLocation + '/static/fonts/PT_Sans-Caption-Web-Regular.ttf',
bratLocation + '/static/fonts/Liberation_Sans-Regular.ttf'
];

head.ready(function() {

var docData = {
// Our text of choice
text : "Ed O'Kelley was the man who shot the man who shot Jesse James.",
// The entities entry holds all entity annotations
entities : [
/* Format: [${ID}, ${TYPE}, [[${START}, ${END}]]]
note that range of the offsets are [${START},${END}) */
['T1', 'Person', [[0, 11]]],
['T2', 'Person', [[20, 23]]],
['T3', 'Person', [[37, 40]]],
['T4', 'Person', [[50, 61]]],
],
};

Util.embed('embedding-entity-example', $.extend({}, collData),
$.extend({}, docData), webFontURLs);
 
});

var collData = {
entity_types: [ {
type : 'Person',
/* The labels are used when displaying the annotion, in this case
we also provide a short-hand "Per" for cases where
abbreviations are preferable */
labels : ['Person', 'Per'],
// Blue is a nice colour for a person?
bgColor: '#7fa2ff',
// Use a slightly darker version of the bgColor for the border
borderColor: 'darken'
} ]
};

</script>
</div>
</div>