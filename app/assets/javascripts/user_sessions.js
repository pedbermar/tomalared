function pintarBotonesHeader() {
  $(".icon-home").button({
    icons : {
      primary : "ui-icon-home"
    },
    text : false
  });
  $(".icon-exit").button({
    icons : {
      primary : "ui-icon-locked"
    },
    text : false
  });
};

$(document).ready(function() {  
          pintarBotonesHeader();
});
        