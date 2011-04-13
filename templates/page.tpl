# -*- coding: utf-8 -*-
<%include file="header.tpl"/>
    <div class="entry">
    <h1 class="entrytitle"><a href="${config.siteurl}${page.url}" rel="bookmark" title="${page.title | h}">${page.title | h}</a></h1>
      <div class="entrymeta">
        Postato da <a href='${config.siteurl}${page.author.url}' title="${page.author.username | h}">${page.author.username | h}</a> il ${page.datetime.strftime("%d/%m/%Y")} alle ${page.datetime.strftime("%H:%M:%S")} in
        % for i, category in enumerate( page.categories ):
          <a href='${config.siteurl}${category.url}'>${category.title | h}</a>
          % if i != len(page.categories) - 1:
          ,
          % endif
        % endfor
      </div>
      <div class="entrybody">
        ${page.content}
      </div>
      <div class="entrymeta">
        Tags: 
        % for i, tag in enumerate( page.tags ):
          <a href='${config.siteurl}${tag.url}'>${tag.title | h}</a>
          % if i != len(page.tags) - 1:
          ,
          % endif
        % endfor
      </div>
      <span class='st_twitter_hcount' displayText='Tweet'></span><span class='st_facebook_hcount' displayText='Facebook'></span> 
    </div>

    <!-- DISQUIS -->
    <div id="disqus_thread"></div>
    <script type="text/javascript">
        var disqus_shortname = 'evilsocket';
        // var disqus_identifier = 'unique_dynamic_id_1234';
        // var disqus_url = 'http://example.com/permalink-to-page.html';

        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>
 
<%include file="footer.tpl"/>
