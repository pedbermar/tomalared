function pintarBotones() {
	$(".borrarPost").button({
		icons : {
			primary : "ui-icon-close"
		},
		text : false
	});
	$(".editarPost").button({
		icons : {
			primary : "ui-icon-document"
		},
		text : false
	});
}

function actualizando() {
	div = $("#posts").find(".post");
	options = "";
	if (div.length > 0) {
		id = $(div).first().attr("id").split("_")[1];
		options = "&last=" + $("#created_at_" + id).val();
	}
	$.getScript($(location).attr('href') + "?remote=true" + options);
	setTimeout(actualizando, 15000);
}

function actualizado(data) {
	var postsData = $(data).find(".post");
	if (postsData.length > 0) {
		var posts = $("#posts").find(".post");
		if (posts.length > 0) {
			for ( var i = 0; i < postsData.length; i++) {
				for ( var j = 0; j < posts.length; j++) {
					var divData = postsData.get(i);
					var div = posts.get(j);
					var idData = $(divData).attr("id");
					var idPost = $(div).attr("id");
					if (idData.split("_")[1] < idPost.split("_")[1]) {
						$("#" + idPost).after(divData);
						postsData.splice(i, 1);
					} else if (idData.split("_")[1] > idPost.split("_")[1]
							&& j == 0) {
						$("#" + idPost).before(divData);
						postsData.splice(i, 1);
					} else if (idData.split("_")[1] = idPost.split("_")[1]) {
						$("#" + idPost).find(".titulo").html($(divData).find(".titulo").html());
						$("#" + idPost).find(".new-foto").html($(divData).find(".new-foto").html());
						$("#" + idPost).find(".comments-old").html($(divData).find(".comments-old").html());
						postsData.splice(i, 1);
					}
					if ($(data).find("#" + idPost).length == 0) {
						$("#" + idPost).remove();
						posts.splice(j, 1);
					}
				}
			}
		} else {
			$("#posts").html(data);
		}
	}
	pintarBotones();
}

function vueltaPost() {
	setTimeout(function() {
		pintarBotones();
		$("#cargando").hide();
		$("#posts").find(".post").first().removeAttr("style");
	}, 1000);
};

function exitoPost() {
	$("#posts").find(".post").first().effect("highlight", {}, "fast",
			vueltaPost());
}

$(document).ready(function() {
	$("#save").submitWithAjax();
	$("#tumblear").button();
	$("#new-radio").buttonset();
	$("#actualizar").on("click", function(event, data) {
		actualizado(data);
	})
	$("input:radio").click(function() {
		if ($(this).val() == "quote") {
			$("#tags").hide();
		} else {
			$("#tags").show();
		}
		if ($(this).val() == "post") {
			$("#post_title").show();
		} else {
			$("#post_title").hide();
		}
		if ($(this).val() == "image") {
			$("#archivo").show();
		} else {
			$("#archivo").hide();
		}
	});
	pintarBotones();
	setTimeout(actualizando, 15000);
});