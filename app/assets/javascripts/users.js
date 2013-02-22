$(document).ready(function() {
	$("#tabs").tabs();
	$("#tabs-board").tabs();
	$('.tags-cloud-groups').tagcloud({
		type : "sphere",
		centrex : 100,
		centrey : 60,
		zoom : 100,
		sizemin : 10,
		sizemax : 20,
		power : .3
	});
	$('.tags-cloud-populars').tagcloud({
		type : "sphere",
		centrex : 60,
		centrey : 60,
		zoom : 200,
		sizemin : 10,
		sizemax : 20,
		power : .3
	});
	$('.popbox-mentions').popbox({
		'open' : '.open-mentions',
		'box' : '.box-mentions',
		'arrow' : '.arrow-mentions',
		'arrow_border' : '.arrow-border-mentions',
		'close' : '.close-mentions'
	});
	$('.popbox-groups').popbox({
		'open' : '.open-groups',
		'box' : '.box-groups',
		'arrow' : '.arrow-groups',
		'arrow_border' : '.arrow-border-groups',
		'close' : '.close-groups'
	});
	$('.popbox-comments').popbox({
		'open' : '.open-comments',
		'box' : '.box-comments',
		'arrow' : '.arrow-comments',
		'arrow_border' : '.arrow-border-comments',
		'close' : '.close-comments'
	});
	$("div.nube-tags").on("click", "a", function(event) {
		$("#notice").hide();
		if ($("#remote").length > 0) {
			$("#cargandoPag").dialog("open");
			$("#cabeceraMuneco").hide();
			$("#formulario").hide();
			$("#posts").hide();
			var url = $(location).attr('protocol') + "//" + $(location).attr('host') + $(this).attr('href');
			$("#remote").val(url);
			$("#posts").html("");
			$.getScript(url + "?remote=true");
			return false;
		}
	});
});
