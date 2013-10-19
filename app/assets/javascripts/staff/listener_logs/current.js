$(function() {
  
  var updateValues = function() {
    $.get('/staff/listener_logs/current', function(data) {
      $('#hd2_128').text(data.hd2_128);
      $('#main_128').text(data.main_128);
      $('#main_24').text(data.main_24);
    });
  };

  updateValues();

  var updateInterval = setInterval(updateValues, 10000);

});