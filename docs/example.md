---
layout: page
title: Brat example page
subtitle: This page is just a test now
---


<div id="main" class="center">
<div id="content">

<div id="embedding-entity-example"></div>

<script type="text/javascript">

head.js(
// External libraries
'brat/client/lib/jquery.min.js',
'brat/client/lib/jquery.svg.min.js',
'brat/client/lib/jquery.svgdom.min.js',


// brat helper modules
'brat/client/src/configuration.js',
'brat/client/src/util.js',
'brat/client/src/annotation_log.js',
'brat/client/lib/webfont.js',
// brat modules
'brat/client/src/dispatcher.js',
'brat/client/src/url_monitor.js',
'brat/client/src/visualizer.js'
);

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
$.extend({}, docData));
 
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