$(document).ready(function() {
	$("#tabs").tabs();
	$("#tabs-board").tabs();
	$('.tags-cloud-groups').tagcloud({		
		centrex : 10,
		centrey : 30,
		zoom : 300,
		min_zoom : 150,
		max_zoom : 600,
		min_font_size: 7, 
		max_font_size: 32,
		rotate_factor: 10  		
	});
	$('.tags-cloud-populars').tagcloud({		
		centrex : -20,
		centrey : 30,
		zoom : 300,
		min_zoom : 150,
		max_zoom : 600,
		min_font_size: 7, 
		max_font_size: 32,
		rotate_factor: 10    
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
	$(".popbox-scroll").on("click", "div.board-munecos", function(event) {
		$("#notice").hide();
		if ($("#remote").length > 0) {
			$("#cargandoPag").dialog("open");
			$("#cabeceraMuneco").hide();
			$("#formulario").hide();
			$("#posts").hide();
			var url = $(location).attr('protocol') + "//" + $(location).attr('host') + $(this).child("a").attr('href');
			$("#remote").val(url);
			$("#posts").html("");
			$.getScript(url + "?remote=true");
			return false;
		}
	});

	$( ".cerrar-condiciones" ).click(function() {
		$( ".condiciones" ).hide( "drop", { direction: "down" }, "slow" );
	});
	$( ".condicion" ).click(function() {
	  	$( ".condiciones" ).show( "fold", 1000 );
	});
});