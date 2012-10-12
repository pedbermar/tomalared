function actualizandoComments() {
	div = $("#comments").find(".comment");
	options = "";
	if (div.length > 0) {
		id = $(div).first().attr("id").split("_")[1];
		options = "&last=" + $("#created_at_" + id).val();
	}
	$.getScript($(location).attr('href') + "?remote=true" + options);
	setTimeout(actualizandoComments, 10000);
}

function actualizadoComments(data) {
	var commentsData = $(data).find(".comment");
	if (commentsData.length > 0) {
		var comments = $("#comments").find(".comment");
		if (comments.length > 0) {
			for ( var i = 0; i < commentsData.length ; i++) {
				for ( var j = 0; j < comments.length; j++) {
					var divData = commentsData.get(i);
					var div = comments.get(j);
					var idData = $(divData).attr("id");
					var idPost = $(div).attr("id");
					if(idData.split("_")[1] < idPost.split("_")[1]){
						$("#" + div).after(divData);
						commentsData.splice(i, 1);
					}else if(idData.split("_")[1] > idPost.split("_")[1] && j == 0){
						$("#" + div).before(divData);
						commentsData.splice(i, 1);
					}else if(idData.split("_")[1] = idPost.split("_")[1]){
						commentsData.splice(i, 1);
					}
					if ($(data).find("#" + idPost).length == 0) {
						$("#" + idPost).remove();
						comments.splice(j, 1);
					}
				}
			}
		} else {
			$("#comments").html(data);
		}
	}
}

function vuelta() {
	setTimeout(function() {
		$("#comments").find(".comment").first().removeAttr("style");
		$("#cargando").hide();
	}, 1000);
};

function exito() {
	$("#comments").find(".comment").last().effect("highlight", {}, "fast", vuelta());
}

$(document).ready(function() {
	$("#comentar").button();
	$(".borrarComentario").button({
        icons: {
            primary: "ui-icon-trash"
        },
        text: false
	});
	$(".editarComentario").button({
        icons: {
            primary: "ui-icon-document"
        },
        text: false
	});
	$("#actualizar").on("click", function(event, data) {
		actualizadoComments(data);
	})
	setTimeout(actualizandoComments, 10000);
});