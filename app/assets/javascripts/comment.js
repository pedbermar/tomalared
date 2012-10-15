function pintarBotones() {
	$(".borrarComentario").button({
		icons : {
			primary : "ui-icon-trash"
		},
		text : false
	});
	$(".editarComentario").button({
		icons : {
			primary : "ui-icon-document"
		},
		text : false
	});
}

function vueltaComment() {
	setTimeout(function() {
		pintarBotones();
		$(".comments-old").find(".comment").first().removeAttr("style");
	}, 1000);
};

function exitoComment() {
	$(".comments-old").find(".comment").last().effect("highlight", {}, "fast",
			vueltaComment());
}

$(document).ready(function() {
	$(".comentar").button();
	pintarBotones();
});