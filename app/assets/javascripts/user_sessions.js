function pintarBotonesHeader() {
  $(".icon-home").button({
    icons : {
      primary : "ui-icon-wrench"
    },
    text : false
  });
  $(".icon-exit").button({
    icons : {
      primary : "ui-icon-locked"
    },
    text : false
  });
  
    $("#open-publicar").button({
    icons : {
      primary : "ui-icon-pencil"
    }    
  });
};

$(document).ready(function() {  
          pintarBotonesHeader();
});
        