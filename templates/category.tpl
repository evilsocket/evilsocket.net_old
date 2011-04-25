# -*- coding: utf-8 -*-
<%include file="header.tpl"/>
  <h3 class="entrytitle">Archivio della categoria <span style='color:#C7FF68;'>${category.title | h}</span> <em style="font-size:12px; font-weight:normal;">(${len(category.items)} Articoli)</em></h3>
  %if len(category.children):
    <br/>
    <ul id="subcats">
      %for sub in category.children:
        <li><h2><a href="${config.siteurl}${sub.url}" title="Visualizza tutti gli articoli archiviati in ${sub.title | h}">${sub.title | h}</a> <label>(${len(sub.items)} Articoli)</label></h2></li> 
      %endfor
    </ul>
  %endif
  <br/>
  <br/>
  % for page in pager.getCurrentPages():
    <div class="entry">
      <h3 class="entrytitle">
        <a href="${config.siteurl}${page.url}" rel="bookmark" title="${page.title | h}">${page.title | h}</a></h3>
        <div class="entrymeta">
          Postato da <a href='${config.siteurl}${page.author.url}' title="${page.author.username | h}">${page.author.username | h}</a> il ${page.datetime.strftime("%d/%m/%Y")} alle ${page.datetime.strftime("%H:%M:%S")} in
          % for i, c in enumerate( page.categories ):
            <a href='${config.siteurl}${c.url}'>${c.title | h}</a>
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
        <a href='${config.siteurl}${category.url}'>${ pagen }</a>
      % else:
        <a href='${config.siteurl}categories/${category.name}-${pagen}.${config.page_ext}'>${ pagen }</a>
      % endif
    % endfor
  </div>
  % endif
  
<%include file="footer.tpl"/>
