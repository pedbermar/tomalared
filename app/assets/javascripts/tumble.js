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