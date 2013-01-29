$(document).ready(function() {
	$("#tabs").tabs();
	$("#tabs-board").tabs();
});

$(function() {
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
	$("div.nube-tags").on("click", "a", function(event) {
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