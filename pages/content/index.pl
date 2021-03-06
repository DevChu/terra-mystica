{
    layout => 'sidebar',
    scripts => [ "/stc/common.js",
                 "/stc/index.js" ],
    title => 'Online Terra Mystica',
    content => read_then_close(*DATA)
}

__DATA__

<div class="motd" style="display: block">
    Season 15 of the Terra Mystica tournament will start on October 1st.
    Sign ups are now open on the <a href="http://tmtour.org">tournament website</a>, with discussion on the <a href="https://boardgamegeek.com/thread/1639446/signup-season-15-4p-tm-tour-has-started">BGG thread</a>.
</div>

<h4>Your Active / Recently Finished Games</h4>
<table id="yourgames-active" class="gamelist"></table>

<h4>Games you Administrate</h4>
<table id="yourgames-admin" class="gamelist"></table>

<div id="news" class="changelog"></div>

<script language="javascript">
fetchGames("yourgames-active", "user", "running", listGames);
fetchGames("yourgames-admin", "admin", "running", listGames);

setInterval(function() {
fetchGames("yourgames-active", "user", "running", listGames);
}, 5*60*1000);

fetchChangelog(function(news) {
    showChangelog(news, $("news"), "News", { "change": true, "blog": true },
                  10 * 86400)
});
</script>

<div class="motd" style="display: none">
The <a href="https://boardgamegeek.com/article/23645673#23645673">discussion
is open</a> for a new revision of Loon Lakes.
</div>
