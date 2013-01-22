$(document).ready(function() {
	$( "#tabs" ).tabs();
	$( "#tabs-board" ).tabs();	
});

$(function(){
    $('.tags-cloud-groups').tagcloud({type:"sphere",centrex:100,centrey:60,zoom:100,sizemin:10,sizemax:20,power:.3});    
    $('.tags-cloud-populars').tagcloud({type:"sphere",centrex:60,centrey:60,zoom:200,sizemin:10,sizemax:20,power:.3});
});