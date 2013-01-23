function pintarBotonesVote() {
	$(".iconsMas").button({
		icons : {
			primary : "ui-icon-arrowthick-1-n"
		},
		text : false
	});
	$(".iconsMasDisable").button({
		icons : {
			primary : "ui-icon-arrowthick-1-n"
		},
		text : false
	});
	$('.iconsMasDisable').button("disable");

	$(".iconsMenos").button({
		icons : {
			primary : "ui-icon-arrowthick-1-s"
		},
		text : false
	});
	$(".iconsMenosDisable").button({
		icons : {
			primary : "ui-icon-arrowthick-1-s"
		},
		text : false
	});
	$('.iconsMenosDisable').button("disable");

	$(".iconShare").button({
		icons : {
			primary : "ui-icon-arrowreturnthick-1-e"
		},
		text : false
	});
	$(".iconUnshare").button({
		icons : {
			primary : "ui-icon-trash"
		},
		text : false
	});

	$(".iconsMasComentario").button({
		icons : {
			primary : "ui-icon-squaresmall-plus"
		},
		text : false
	});
	$(".iconsMasComentarioDisable").button({
		icons : {
			primary : "ui-icon-squaresmall-plus"
		},
		text : false
	});
	$('.iconsMasComentarioDisable').button("disable");

	$(".iconsMenosComentario").button({
		icons : {
			primary : "ui-icon-squaresmall-minus"
		},
		text : false
	});
	$(".iconsMenosComentarioDisable").button({
		icons : {
			primary : "ui-icon-squaresmall-minus"
		},
		text : false
	});
	$('.iconsMenosComentarioDisable').button("disable");
}


$(document).ready(function() {
	pintarBotonesVote();
});

