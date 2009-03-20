$(document).ready(function(){
  
  // toggle grid
  $("#framer-tools .togglegrid").click(function() {
    if ($("#framer-tools .togglegrid").text() == 'hide grid'){
      $(".togglegrid").text("show grid");
      $("#wrap").removeClass("showgrid");
      $.cookie('framergrid', 'hidden', { expires: 365 });
    } else {
      $(".togglegrid").text("hide grid");
      $.cookie('framergrid', 'visible', { expires: 365 });
      $("#wrap").addClass("showgrid");
    }
    return false;
  });
  // toggle grid with cookie
  var framergrid = $.cookie('framergrid'); 
  if (framergrid == 'visible' || framergrid == undefined) {
    $("#wrap").addClass("showgrid");
    $("#framer-tools .togglegrid").text("hide grid");
    }else{
    $("#wrap").removeClass("showgrid");  
    $("#framer-tools .togglegrid").text("show grid");
  }
  // toggle grid from demo
  $("#demo-link .togglegrid").text($("#framer-tools .togglegrid").text())
  $("#demo-link .togglegrid").click(function() {
    if ($("#demo-link  .togglegrid").text() == 'hide grid'){
      $(".togglegrid").text("show grid");
      $("#wrap").removeClass("showgrid");
      $.cookie('framergrid', 'hidden', { expires: 365 });
    } else {
      $(".togglegrid").text("hide grid");
      $.cookie('framergrid', 'visible', { expires: 365 });
      $("#wrap").addClass("showgrid");
    }
    return false;
  });
  
  $("#framer-tools #framer-wrap").hide();
  
  // toggle framer menu
  $("#framer-tools .toggleframer").click(function() {
    if ($("#framer-tools .toggleframer").text() == 'hide tools'){
      $("#framer-tools .toggleframer").text("show tools");
      $("#framer-tools #framer-wrap").animate({height:'hide'});
      $.cookie('framertools', 'hidden', { expires: 365 });
    } else {
      $("#framer-tools .toggleframer").text("hide tools");
      $.cookie('framertools', 'visible', { expires: 365 });
      $("#framer-tools #framer-wrap").animate({height:'show'});
    }
    return false;
  });
  // toggle framer menu with cookie
  var framertools = $.cookie('framertools'); 
  if (framertools == 'false' || framertools == undefined) {
    $("#framer-tools .toggleframer").text("hide tools");
    $("#framer-tools #framer-wrap").show();
    }else{
    $("#framer-tools .toggleframer").text("show tools");  
    $("#framer-tools #framer-wrap").hide();
  }
  
});