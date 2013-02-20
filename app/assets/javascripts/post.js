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

function endlessPost() {
	$(document).endlessScroll({
		fireOnce : false,
		fireDelay : 500,
		ceaseFireOnEmpty : false,
		loader : "<img src=\"/gfx/loading.gif\">",
		callback : function(fireSequence, pageSequence, scrollDirection) {
			var last = $("div.post:last input.created_at").val();
			if (scrollDirection == "prev") {
				last = $("div.post:first input.created_at").val();
			}
			$.ajax({
				url : $("#remote").val() == "" ? window.location.href : $("#remote").val(),
				data : {
					last : last,
					soloposts : true,
					remote : true,
					direccion : scrollDirection,
					veces : fireSequence,
					pag : pageSequence
				},
				dataType : 'script'
			});
		}
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
	if ($("#infinite-scroll").length == 0)
		$("#posts").after("<div id=\"infinite-scroll\"><\/div>")
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
						if ($(divData).find("div.sharePost").length > 0)
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
			$("#posts").html(postsData);
		}
	}
	$("#posts").show();
	pintarBotonesPost();
	pintarBotonesComment();
	pintarBotonesVote();
	endlessPost();
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
	$(document).on("click", ".linkRemote", function(event) {
		$("#notice").hide();
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
		$("#notice").hide();
		var url = $(location).attr('protocol') + "//" + $(location).attr('host') + $(this).attr('href');
		$.getScript(url + "?remote=true");
		return false;
	});
	pintarBotonesPost();
	endlessPost();
	//setTimeout(actualizando, 15000);
}); 