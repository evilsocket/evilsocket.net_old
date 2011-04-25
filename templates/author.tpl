# -*- coding: utf-8 -*-
<%include file="header.tpl"/>
  <h3 class="entrytitle"><span style='color:#C7FF68;'>${author.username | h}</span></h3>
  <div class="entry">
    <div class="entrybody">
      ${author.content}
    </div>
    <div class="entrymeta"><b>email :</b> ${author.email.replace( '@', ' [at] ' ).replace( '.', ' [dot] ')}</div>
  </div>

  <h3 class="entrytitle">Ha scritto ${len(author.items)} articoli:</h3>
  <br/>
  <br/>
  % for page in pager.getCurrentPages():
    <div class="entry">
      <h3 class="entrytitle">
        <a href="${config.siteurl}${page.url}" rel="bookmark" title="${page.title | h}">${page.title | h}</a></h3>
        <div class="entrymeta">
          Postato da <a href='${config.siteurl}${page.author.url}' title="${page.author.username | h}">${page.author.username | h}</a> il ${page.datetime.strftime("%d/%m/%Y")} alle ${page.datetime.strftime("%H:%M:%S")} in
          % for i, category in enumerate( page.categories ):
            <a href='${config.siteurl}${category.url}'>${category.title | h}</a>
            % if i != len(page.categories) - 1:
            ,
            % endif
          % endfor
          <br/>
          Tags: 
          % for i, t in enumerate( page.tags ):
            <a href='${config.siteurl}${t.url}'>${t.title | h}</a>
            % if i != len(page.tags) - 1:
            ,
            % endif
          % endfor
        </div>
    </div>
  % endfor

  % if pager.getTotalPages() > 1:
  <div id="pager">
    <label>PAGINE</label>
    % for pagen in range( 1, pager.getTotalPages() + 1 ):
      % if pagen == pager.getCurrentPageNumber():
        <b>${ pagen }</b>
      % elif pagen == 1:
        <a href='${config.siteurl}${author.url}'>${ pagen }</a>
      % else:
        <a href='${config.siteurl}members/${author.name}-${pagen}.${config.page_ext}'>${ pagen }</a>
      % endif
    % endfor
  </div>
  % endif

<%include file="footer.tpl"/>
