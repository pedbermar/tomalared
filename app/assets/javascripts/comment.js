function pintarBotonesComment() {
	$(".borrarComentario").button({
		icons : {
			primary : "ui-icon-trash"
		},
		text : false
	});
	$(".comentar").button();
}

function vueltaComment() {
	setTimeout(function() {
		pintarBotonesComment();
		pintarBotonesVote(); 
		$(".comments-old").find(".comment").first().removeAttr("style");
	}, 1000);
};

function exitoComment() {
	$(".comments-old").find(".comment").last().effect("highlight", {}, "fast",
			vueltaComment());
}

$(document).ready(function() {
	$(".comentar").button();
	$(".comentar").click(function() {
		var texto = $(this).parent().find("textarea.comment-new").val();
		if (texto.length == 0) {
			alert("El mensaje está vacío ¿seguro no quieres decir nada?");
			return false;
		}
	});
	$(".formComentContent").charcount({
		position: 'after'
	});
	pintarBotonesComment();
	pintarBotonesVote(); 
});