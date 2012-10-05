function vuelta() {
	setTimeout(function() {
		$("#posts").find("div").first().removeAttr("style");
	}, 1000 );
};

function exito(){
	$("#posts").find("div").first().effect("highlight", {}, "fast", vuelta());
}

$(document).ready(function() {
	$("#save_post").submitWithAjax();
	$("#delete").submitWithAjax();
	$("#tumblear").button();
	$("#new-radio").buttonset();
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
});