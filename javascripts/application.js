$(document).ready(function(){

  // show grid
  $(".togglegrid").toggle(function () {
    $("#wrap").addClass("showgrid");
  }, function () {
    $("#wrap").removeClass("showgrid");
  });

});