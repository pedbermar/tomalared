function pintarBotonesVote() {
  $(".iconsMas").button({
    icons : {
      primary : "ui-icon-plusthick"
    },
    text : false
  });
  $(".iconsMasDisable").button({
    icons : {
      primary : "ui-icon-plusthick"
    },
    text : false
  });
  $('.iconsMasDisable').button("disable");
  
  
  $(".iconsMenos").button({
    icons : {
      primary : "ui-icon-minusthick"
    },
    text : false
  });
  $(".iconsMenosDisable").button({
    icons : {
      primary : "ui-icon-minusthick"
    },
    text : false
  });
  $('.iconsMenosDisable').button("disable");
  
  $(".iconShare").button({
    icons : {
      primary : "ui-icon-link"
    },
    text : false
  });
  $(".iconUnshare").button({
    icons : {
      primary : "ui-icon-cancel"
    },
    text : false
  });
  
   
  
  $(".iconsMasComentario").button({
    icons : {
      primary : "ui-icon-squaresmall-plus"
    },
    text : false
  });
  $(".iconsMasComentarioDisable").button({
    icons : {
      primary : "ui-icon-squaresmall-plus"
    },
    text : false
  });
  $('.iconsMasComentarioDisable').button("disable");
  
  
  $(".iconsMenosComentario").button({
    icons : {
      primary : "ui-icon-squaresmall-minus"
    },
    text : false
  });
  $(".iconsMenosComentarioDisable").button({
    icons : {
      primary : "ui-icon-squaresmall-minus"
    },
    text : false
  });
  $('.iconsMenosComentarioDisable').button("disable");
}

$(document)
    .ready(
        function() {     
          pintarBotonesVote();
        });
        
