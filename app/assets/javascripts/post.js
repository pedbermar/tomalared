function pintarBotonesPost(postId) {
	$(postId + ".borrarPost").button({
		icons : {
			primary : "ui-icon-trash"
		},
		text : false
	});
	$(postId + ".editarPost").button({
		icons : {
			primary : "ui-icon-document"
		},
		text : false
	});
}

function endlessPost() {
	$(document).endlessScroll({
		fireOnce : false,
		fireDelay : 1000,
		ceaseFireOnEmpty : false,
		intervalFrequency : 2000,
		inflowPixels : 0,
		loader : "<img src=\"/gfx/loading.gif\">",
		callback : function(fireSequence, pageSequence, scrollDirection) {
			if($("div.post").length > 0){
				var last = ($("div.post:last").attr("id")).split("_")[1];
				if (scrollDirection == "prev") {
					last = ($("div.post:first").attr("id")).split("_")[1];
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
		}
	});
}

function actualizando() {
	var data = "";
	var numPost = 0;
	if($(".post").length > 0){
		data += "{ posts: [";
		$(".post").each(function(index){
			var post = ""
			var id = $(this).attr("id").split("_")[1];
			if(numPost == 0)
				post += "{";
			else
				post += ",{";
			post += "id: '" + id + "'"; 
			var fecha = "" + $(this).find("#created_at_" + id).val().replace(/:/g, ".");
			post += ", fecha: '" + fecha + "'";
			var control = "" + $(this).find(".controlTiempo").val();
			post += ", control: '" + control + "'";
			var comments = "";
			var numComment = 0;
			if($(this).find(".comment").length > 0){
				comments += ", comments: [";
				$(this).find(".comment").each(function (index2){
					if($(this).find(".controlTiempo").val() == "S"){
						var idcm = $(this).attr("id").split("_")[1];
						if(numComment == 0)
							comments += "{";
						else
							comments += ",{";
						comments += "id: '" + idcm + "'"; 
						var fechacm = "" + $(this).find("#cmcreate_at_" + idcm).val().replace(/:/g, ".");
						comments += ", fecha: '" + fechacm + "'";
						comments += "}";
						numComment++;
					}
				});
				comments += "]";
			} else {
				comments += ", 'comments': []";
			}
			post += comments + "}";
			if(control == "S" || numComment > 0){
				numPost++;
				data += post;
			}
		});
		data += "]}";
	}
	$.getJSON("/desde", { data: eval(data) }, function(data){
		var i = 0;
		while(data[i] != undefined){
			$("#post_" + data[i]['id'] + " span.tiempo").html(data[i]['texto']);
			var comments = data[i]['comments'];
			var j = 0;
			while(comments[j] != undefined){
				$("#comment_" + comments[j]['id'] + " span.tiempo").html(comments[j]['texto']);
				j++;
			}
			i++;
		}
	});
	setTimeout(actualizando, 15000);
}

function personalizarPag(data) {
	$("#main").html(data);
	if ($("#cargandoPag").dialog("isOpen"))
		$("#cargandoPag").dialog("close");
}

function llegadaPost(notif) {
	var url = $(location).attr("href");
	if($("#remote").length > 0 && $("#remote").val() != "")
		url = $("#remote").val();
	if(url.indexOf("/post/") != -1)
		$.getScript(url + "?notif=true&remote=true&postId=" + notif.post_id);
}

function vueltaPost(idPost) {
	setTimeout(function() {
		$(idPost).removeAttr("style");
	}, 1000);
};

function exitoPost(idPost) {
	pintarBotonesPost(idPost + " ");
	pintarBotonesComment(idPost+ " ", "");
	pintarBotonesVote(idPost+ " ", "");
	inicioComment(idPost+ " ");
	$(idPost).effect("highlight", {}, "fast", vueltaPost(idPost));
}


$(document).ready(function() {
	$("#save").submitWithAjax();
	$(document).on("click", ".linkRemote", function(event) {
		if($("#notice").length > 0)
			$("#notice").remove();
		if($("#error").length > 0)
			$("#error").remove();
		if ($("#remote").length > 0) {
			$('html, body').animate({ scrollTop: 0 }, 0);
			$("#cargandoPag").dialog("open");
			var url = $(location).attr('protocol') + "//" + $(location).attr('host') + $(this).attr('href');
			$("#remote").val(url);
			$.getScript(url + "?remote=true");
			return false;
		}
	});
	$(document).on("click", ".linkRemote2", function(event) {
		if($("#notice").length > 0)
			$("#notice").remove();
		if($("#error").length > 0)
			$("#error").remove();
		var url = $(location).attr('protocol') + "//" + $(location).attr('host') + $(this).attr('href');
		$.getScript(url + "?remote=true");
		return false;
	});
	$("#post_content").charcount({
		position : 'after',
		maxLength : 150,
		preventOverage : false
	});
	$(document).on("mouseover", ".mainPostContent", function() {
		var id = $(this).parent().parent().attr("id");
		$("#" + id + " .ocultarIconos").css("visibility", "visible" );
	}).on("mouseleave", ".mainPostContent", function(){
		var id = $(this).parent().parent().attr("id");
		$("#" + id + " .ocultarIconos").css("visibility", "hidden" );
	});
	pintarBotonesPost("");
	endlessPost();
	setTimeout(actualizando, 15000);
	
	
	  $(".ln[rel^='prettyPhoto']").prettyPhoto({
	  	markup: '<div class="pp_pic_holder"> \
						<div class="ppt">&nbsp;</div> \
						<div class="pp_top"> \
							<div class="pp_left"></div> \
							<div class="pp_middle"></div> \
							<div class="pp_right"></div> \
						</div> \
						<div class="pp_content_container"> \
							<div class="pp_left"> \
							<div class="pp_right"> \
								<div class="pp_content"> \
									<div class="pp_loaderIcon"></div> \
									<div class="pp_fade"> \
										<div class="pp_hoverContainer"> \
											<a class="pp_next" href="#">next</a> \
											<a class="pp_previous" href="#">previous</a> \
										</div> \
										<div id="pp_full_res"></div> \
										<div class="pp_details"> \
											<div class="pp_nav"> \
												<a href="#" class="pp_arrow_previous">Previous</a> \
												<p class="currentTextHolder">0/0</p> \
												<a href="#" class="pp_arrow_next">Next</a> \
											</div> \
											<p class="pp_description"></p> \
											<a class="pp_close" href="#">Close</a> \
										</div> \
									</div> \
								</div> \
							</div> \
							</div> \
						</div> \
						<div class="pp_bottom"> \
							<div class="pp_left"></div> \
							<div class="pp_middle"></div> \
							<div class="pp_right"></div> \
						</div> \
					</div> \
					<div class="pp_overlay"></div>',
			gallery_markup: '<div class="pp_gallery"> \
								<a href="#" class="pp_arrow_previous">Previous</a> \
								<div> \
									<ul> \
										{gallery} \
									</ul> \
								</div> \
								<a href="#" class="pp_arrow_next">Next</a> \
							</div>'
	  });
});
