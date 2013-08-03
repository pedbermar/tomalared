function pintarBotonesVote(postId, commentId) {
	var elemento = postId;
	if(commentId != "")
	{
		elemento = commentId;
	}
	
	$(elemento + ".iconsMas").button();
	$(elemento + ".iconsMasDisable").button();
	$(elemento + '.iconsMasDisable').button("disable");

	$(elemento + ".iconsMenos").button();
	$(elemento + ".iconsMenosDisable").button();
	$(elemento + '.iconsMenosDisable').button("disable");

	$(elemento + ".iconShare").button();
	$(elemento + ".iconUnshare").button();

	$(elemento + ".iconsMasComentario").button();
	$(elemento + ".iconsMasComentarioDisable").button();
	$(elemento + '.iconsMasComentarioDisable').button("disable");

	$(elemento + ".iconsMenosComentario").button();
	$(elemento + ".iconsMenosComentarioDisable").button();
	$(elemento + '.iconsMenosComentarioDisable').button("disable");
}

$(document).ready(function() {
	pintarBotonesVote("", "");
});

