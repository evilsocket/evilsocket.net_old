# -*- coding: utf-8 -*-
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head profile="http://gmpg.org/xfn/11">
		<meta http-equiv="Content-type" content="text/html; charset=${config.charset}" />
    <meta http-equiv="Content-language" content="${config.language}" />
  
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

    <meta name="keywords" content="${ ', '.join( config.keywords ) }" />

		<meta name="generator" content="SWG ${config.version}" />

		<link rel="stylesheet" href="${config.siteurl}/css/style.css" type="text/css" media="screen" /> 
    <link rel="alternate" type="application/rss+xml"  href="${config.siteurl}/feed.xml" title="${config.sitename | h} RSS Feeds">
    <link rel="shortcut icon" type="image/x-icon" href="${config.siteurl}/images/favicon.ico" />
	</head>

	<body id="home" class="log">
		<div id="pagewrap">
      <%include file="sidebar.tpl"/>
      <div id="content">
