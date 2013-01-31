function pintarBotonesComment() {
	$(".borrarComentario").button({
		icons : {
			primary : "ui-icon-trash"
		},
		text : false
	});
	$(".comentar").button();
}

function vueltaComment(post_id) {
	setTimeout(function() {
		pintarBotonesComment();
		pintarBotonesVote(); 
		$("#post_" + post_id + " div.comment").first().removeAttr("style");
	}, 1000);
};

function exitoComment(post_id) {
	$("#post_" + post_id + " div.comment").last().effect("highlight", {}, "fast",
			vueltaComment(post_id));
}

$(document).ready(function() {
	$(".comentar").button();
	$("#body").charCount({
		warning: 20
	});
	$(".comentar").click(function() {
		var texto = $(this).parent().find("textarea.comment-new").val();
		if (texto.length == 0) {
			alert("El mensaje está vacío ¿seguro no quieres decir nada?");
			return false;
		}
	});
	pintarBotonesComment();
	pintarBotonesVote(); 
});