function pintarBotonesComment() {
	$(".borrarComentario").button({
		icons : {
			primary : "ui-icon-trash"
		},
		text : false
	});
	$(".comentar").button();
}

function inicioComment(idPost) {
	var com = ".formComentContent";
	$(idPost + com).charcount({
		position : 'after'
	});
}

function vueltaComment(idPost) {
	pintarBotonesComment();
	pintarBotonesVote();
	$("#post_" + idPost + " .formComentContent").trigger('charcount');
	setTimeout(function() {
		$(".comments-old").find(".comment").first().removeAttr("style");
	}, 1000);
};

function exitoComment(idPost) {
	$(".comments-old").find(".comment").last().effect("highlight", {}, "fast", vueltaComment(idPost));
}


$(document).ready(function() {
	$(".comentar").button();
	$(".comentar").click(function() {
		var texto = $(this).parent().find("textarea#body").val();
		if (texto.length == 0) {
			alert("El mensaje está vacío ¿seguro no quieres decir nada?");
			return false;
		}
	});
	inicioComment("");
	pintarBotonesComment();
	pintarBotonesVote();
}); 