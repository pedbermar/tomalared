function pintarBotonesPost() {
	$(".borrarPost").button({
		icons : {
			primary : "ui-icon-trash"
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
	if ($("#remote").length > 0) {
		var url = $(location).attr('href');
		if ($("#remote").val() != "") {
			url = $("#remote").val()
		}
		$.getScript(url + "?remote=true&soloposts=true");
	}
	setTimeout(actualizando, 15000);
}

function personalizarPag(muneco, data, formulario) {
	if (muneco != "") {
		$("#cabeceraMuneco").html(muneco);
		$("#cabeceraMuneco").show();
	}
	if (formulario != "") {
		$("#formulario").html(formulario);
		$("#formulario").show();
	}
	actualizado(data);
	if ($("#cargandoPag").dialog("isOpen"))
		$("#cargandoPag").dialog("close");
}

function actualizado(data) {
	var postsData = $(data).find(".post");
	if (postsData.length > 0) {
		var posts = $("#posts").find(".post");
		if (posts.length > 0) {
			for (var i = 0; i < postsData.length; i++) {
				for (var j = 0; j < posts.length; j++) {
					var divData = postsData.get(i);
					var div = posts.get(j);
					var idData = $(divData).attr("id");
					var idPost = $(div).attr("id");
					if (idData.split("_")[1] < idPost.split("_")[1]) {
						$("#" + idPost).after(divData);
						postsData.splice(i, 1);
					} else if (idData.split("_")[1] > idPost.split("_")[1] && j == 0) {
						$("#" + idPost).before(divData);
						postsData.splice(i, 1);
					} else if (idData.split("_")[1] = idPost.split("_")[1]) {
						$("#" + idPost).find(".titulo").html($(divData).find(".titulo").html());
						$("#" + idPost).find(".new-foto").html($(divData).find(".new-foto").html());
						$("#" + idPost).find(".postComments").html($(divData).find(".postComments").html());
						$("#" + idPost).find("span.tiempo").html($(divData).find("span.tiempo").html());
						if($(divData).find("div.sharePost").length > 0)
							$("#" + idPost).find("div.sharePost").html($(divData).find("div.sharePost").html());
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
	$("#posts").show();
	pintarBotonesPost();
	pintarBotonesComment();
	pintarBotonesVote();
}

function vueltaPost() {
	setTimeout(function() {
		pintarBotonesPost();
		pintarBotonesComment();
		pintarBotonesVote();
		$("#posts").find(".post").first().removeAttr("style");
	}, 1000);
};

function exitoPost() {
	$("#posts").find(".post").first().effect("highlight", {}, "fast", vueltaPost());
}


$(document).ready(function() {
	$("#save").submitWithAjax();
	$("#tumblear").button();
	$("#new-radio").buttonset();
	$("#cargandoPag").dialog({
		autoOpen : false,
		minHeight : 66,
		minWidth : 66,
		maxWidth : 66,
		draggable : false,
		resizable : false,
		dialogClass : "cargandoPagPost"
	});
	$("#post_content").charCount({
		warning : 0,
		counterText : 'Quote < 140 > Post: '
	});
	$("#tumblear").click(function() {
		if ($("#post_content").val().length == 0) {
			alert("El mensaje está vacío ¿seguro no quieres decir nada?");
			return false;
		}
	});
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
	$(document).on("click", ".linkRemote", function(event) {
		if ($("#remote").length > 0) {
			$("#cargandoPag").dialog("open");
			$("#cabeceraMuneco").hide();
			$("#formulario").hide();
			$("#posts").hide();
			var url = $(location).attr('protocol') + "//" + $(location).attr('host') + $(this).attr('href');
			$("#remote").val(url);
			$("#posts").html("");
			$.getScript(url + "?remote=true");
			return false;
		}
	});
	$(document).on("click", ".linkRemote2", function(event) {
		var url = $(location).attr('protocol') + "//" + $(location).attr('host') + $(this).attr('href');
		$.getScript(url + "?remote=true");
		return false;
	});
	pintarBotonesPost();
	setTimeout(actualizando, 15000);
}); 