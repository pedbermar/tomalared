function pintarBotonesVote(postId, commentId) {
	var elemento = postId;
	if(commentId != ""){
		elemento = commentId;
	}
	$(elemento + ".iconsMas").button({
		icons : {
			primary : "ui-icon-arrowthick-1-n"
		},
		text : false
	});
	$(elemento + ".iconsMasDisable").button({
		icons : {
			primary : "ui-icon-arrowthick-1-n"
		},
		text : false
	});
	$(elemento + '.iconsMasDisable').button("disable");

	$(elemento + ".iconsMenos").button({
		icons : {
			primary : "ui-icon-arrowthick-1-s"
		},
		text : false
	});
	$(elemento + ".iconsMenosDisable").button({
		icons : {
			primary : "ui-icon-arrowthick-1-s"
		},
		text : false
	});
	$(elemento + '.iconsMenosDisable').button("disable");

	$(elemento + ".iconShare").button({
		icons : {
			primary : "ui-icon-arrowreturnthick-1-e"
		},
		text : false
	});
	$(elemento + ".iconUnshare").button({
		icons : {
			primary : "ui-icon-trash"
		},
		text : false
	});

	$(elemento + ".iconsMasComentario").button({
		icons : {
			primary : "ui-icon-squaresmall-plus"
		},
		text : false
	});
	$(elemento + ".iconsMasComentarioDisable").button({
		icons : {
			primary : "ui-icon-squaresmall-plus"
		},
		text : false
	});
	$(elemento + '.iconsMasComentarioDisable').button("disable");

	$(elemento + ".iconsMenosComentario").button({
		icons : {
			primary : "ui-icon-squaresmall-minus"
		},
		text : false
	});
	$(elemento + ".iconsMenosComentarioDisable").button({
		icons : {
			primary : "ui-icon-squaresmall-minus"
		},
		text : false
	});
	$(elemento + '.iconsMenosComentarioDisable').button("disable");
}


$(document).ready(function() {
	pintarBotonesVote("", "");
});

