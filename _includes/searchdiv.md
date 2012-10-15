    <div id="searchdiv">
<script type="text/javascript">
function do_search() {
  run_search(function doit() {
  var resultsdiv = $('div#results');
  var itemsdiv = $('div#items');

  if (final_results.length > 0) {
    html = '<ul>';
    $.each(final_results, function(idx,obj) {
      var title = obj["t"];
      var link = obj["u"];
      html += '<li><a href="'+link+'">'+title+'</a></li>';
    });
    html += '</ul>';
    itemsdiv.html(html);
  } else {
    itemsdiv.html('<p class="error">No search results found.</p>');
  }

  if (!resultsdiv.is(":visible")) {
    resultsdiv.css({top:0,left:0,width:"300px","max-height":"100px"}).position({
      my: "left top",
      at: "left bottom",
      of: "input#searchbox",
      offset: "0 0",
      collision: "none"
    }).fadeIn();
  }
  });
}

function close_results() {
  var resultsdiv = $('div#results');
  if (resultsdiv.is(":visible")) {
    resultsdiv.fadeOut();
  }
}
</script>
      <input id="searchbox" class="search" type="text" />
      <button id="searchbutton" class="btn btn-primary search" type="button" onclick="do_search();" /><i class="icon-search"></i> Search</button>
      <div id="results" class="menu">
        <!--<a href="javascript:close_results();"><img src="/images/cancel.png" /></a>-->
        <input type="image" src="/images/cancel.png" onclick="javascript:close_results();" />
        <div id="items"></div>
      </div>
    </div>
