function aspectoUser(){
	$("#imageUser").button();
	$("#datosUser").button();
	$("#claveUser").button();
	$("#borrarUser").button();	
	$("#crearUser").button();	
	$("#tabs").tabs();
	$("#formUser").submitWithAjax();
}

$(document).ready(function() {
	aspectoUser();
	$("#tabs-popbox").tabs();
	$('.tags-cloud-groups').tagcloud({		
		centrex : 55,
		centrey : 55,
		zoom : 100,
		min_zoom : 50,
		max_zoom : 200,
		min_font_size: 7, 
		max_font_size: 32,
		rotate_factor: 10  		
	});
	$('.tags-cloud-populars').tagcloud({		
		centrex : 55,
		centrey : 55,
		zoom : 100,
		min_zoom : 50,
		max_zoom : 200,
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
	$('.popbox-favoritos').popbox({
		'open' : '.open-favoritos',
		'box' : '.box-favoritos',
		'arrow' : '.arrow-favoritos',
		'arrow_border' : '.arrow-border-favoritos',
		'close' : '.close-favoritos'
	});
	
	$("div.nube-tags").on("click", "a", function(event) {
		$.address.value($(this).attr('href'));
		return false;
	});
	$(".popbox-scroll").on("click", "div.board-munecos", function(event) {
		$.address.value($(this).attr('href'));
		return false;
	});

	$(document).on("click", ".cerrar-condiciones", function(event) {
		$( ".condiciones" ).hide( "drop", { direction: "down" }, "slow" );
	});
	$(document).on("click", ".condicion", function(event) {
	  	$( ".condiciones" ).show( "fold", 1000 );
	});

	$(document).on("click", "#imageUser", function(event) {
		$("#formImageUser").ajaxSubmit({
			beforeSubmit: function(a,f,o) {
				o.dataType = 'json';
			},
			complete: function(XMLHttpRequest, textStatus) {
				$.address.value("/crop");
			},
		});
		return false;
	});
});