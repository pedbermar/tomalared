// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// 		.JS LLAMADOS POR RAILS
//= require jquery
//= require jquery_ujs
//= require private_pub
//
// 		NUESTOS .JS
//= require vote
//= require users
//= require user_sessions
//= require search
//= require post
//= require comment
//= require notification
//= require charCount
//
//		LIBRERIAS DE JQUERY
//= require libs/plugins
//= require libs/lightbox
//= require libs/modernizr-2.0.6.min
//= require libs/popbox
//= require libs/gumby
//= require libs/gumby.min
//= require libs/jquery-ui
//= require libs/jquery.endless-scroll
//= require libs/jquery.color
//= require libs/jquery.Jcrop
//= require libs/jquery.mousewheel.min
//= require libs/jquery.tagsphere.min

function resetForm($form) {
	$form.find('input:text, input:password, input:file, select, textarea').val('');
	$form.find('input:radio, input:checkbox').removeAttr('checked').removeAttr('selected');
}

function esNumero(num) {
	var regExp = new RegExp('^\\d+$');
	return regExp.test(num);
}

jQuery.ajaxSetup({
	'beforeSend' : function(xhr) {
		xhr.setRequestHeader("Accept", "text/javascript")
	}
})

jQuery.fn.submitWithAjax = function() {
	this.submit(function() {
		$.post(this.action, $(this).serialize(), function() {
		}, "script");
		return false;
	})
	return this;
};

$(document).ready(function() {
	$("#delete").submitWithAjax();
	$("#new").submitWithAjax();

	$("#form-new").dialog({
		autoOpen : false,
		resizable : false,
		height : 180,
		width : 600,
		closeOnEscape : true
	});

	$("#open-publicar").click(function() {
		$("#post_content").val("");
		if ($("#destinatario").val() != "")
			$("#post_content").val($("#destinatario").val()).trigger('update');
		else
			$("#post_content").trigger('charcount');
		$("#form-new").dialog("open");
		$("#post_content").focus();
	});

	$("#tumblear").click(function() {
		$("#form-new").dialog("close");
	});
});
