// Search form and Searching suggests
$(function() {
  var user_id = $('#user_id').val();
  $('.srch-icon').click(function() {
    $('#search-zone').toggle(300);
  });
  $('#search-suggests').autocomplete({
    source: function(req, res){
      $.ajax({
        url: `/users/${user_id}/search_suggests`,
        type: 'GET',
        cache: false,
        dataType: 'json',
        data: {
          keyword: req.term,
          suggests_max_num: 5
        },
        success: function(data){
          res(data);
        },
        error: function(xhr, ts, err){
          res(['']);
        }
      });
    },
    autoFocus: true
  });
});