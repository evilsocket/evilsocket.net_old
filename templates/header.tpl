# -*- coding: utf-8 -*-
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head profile="http://gmpg.org/xfn/11">
    <meta http-equiv="Content-type" content="text/html; charset=${config.charset}" />
    <meta http-equiv="Content-language" content="${config.language}" />
    <meta name="google-site-verification" content="6qdVG0z0lac2ceITCoTCNm15CPp3K9Sq41_5IK4OLKM" />
  
    <title>
    %if page != UNDEFINED and page.title != 'index':
      ${config.sitename | h} | ${page.title | h}
    %elif category != UNDEFINED:
      ${config.sitename | h} | ${category.title | h}
    %elif tag != UNDEFINED:
      ${config.sitename | h} | ${tag.title | h}
    %elif author != UNDEFINED:
      ${config.sitename | h} | ${author.username | h}
    %else:
      ${config.sitename | h}
    %endif

    %if pager != UNDEFINED and pager.getTotalPages() > 2 and pager.getCurrentPageNumber() != 1:
      | Pagina ${pager.getCurrentPageNumber()} 
    %endif
    </title>

    %if page != UNDEFINED and page.title != 'index':
      <meta name="keywords" content="${ ', '.join( [ t.title for t in page.tags ] ) }" />
      <%
        import re

        description = re.sub( r'<[^>]*?>', ' ', page.content ).strip()[:150]
      %>
      <meta name="description" content="${description | h}" />  
    %else:
      <meta name="keywords" content="${ ', '.join( config.keywords ) }" />
      <meta name="description" content="evilsocket.net, hacking, extreme programming and vodka!" />
    %endif
    
    <meta name="generator" content="SWG ${config.version}" />

    <link rel="stylesheet" href="${config.siteurl}/css/style.css" type="text/css" media="screen" /> 
    <link rel="alternate" type="application/rss+xml"  href="${config.siteurl}feed.xml" title="${config.sitename | h} RSS Feeds" />
    <link rel="shortcut icon" type="image/x-icon" href="${config.siteurl}images/favicon.ico" />
    <link rel='index' title="${config.sitename}" href="${config.siteurl}" />
    
    %if page != UNDEFINED and page.title != 'index':
      <link rel="canonical" href="${config.siteurl}${page.url}" />
    %endif

    <script type="text/javascript">
    // <![CDATA[
      function translateTo( lang ){
        window.open( 'http://www.google.com/translate?sl=it&tl=' + lang + '&u=' + encodeURIComponent(location.href) ); 
        return false;      
      }
    // ]]>
    </script>

    <script type="text/javascript">var switchTo5x=true;</script>
    <script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
    <script type="text/javascript">stLight.options({publisher:'49e18499-d632-4c01-926d-d97c8004aab9'});</script>

    </head>

    <body id="home" class="log">
    <a href="http://github.com/evilsocket" target="_blank">
      <img alt="Fork me on GitHub" src="${config.siteurl}images/fork-me-on-github.png" style="position: fixed; top: 0; right: 0; border: 0" />
    </a>
    <div id="pagewrap">
      <%include file="sidebar.tpl"/>
      <div id="content">
