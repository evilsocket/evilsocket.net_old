<?php

$comments = array();

foreach( glob("*.txt") as $filename ){
  $data = file_get_contents($filename);
  $data = preg_replace('#(\s*)\[cc([^\s\]_]*(?:_[^\s\]]*)?)([^\]]*)\](.*?)\[/cc\2\](\s*)#sie', 'PerformHighlightCodeBlock(\'\\4\', \'\\3\', $data, \'\\2\', \'\\1\', \'\\5\');', $data );
  $data = preg_replace('#(\s*)\<code(.*?)\>(.*?)\</code\>(\s*)#sie', 'PerformHighlightCodeBlock(\'\\3\', \'\\2\', $data, \'\', \'\\1\', \'\\4\');', $data );
 // $data = preg_replace('#(\s*)(\[cc[^\s\]_]*(?:_[^\s\]]*)?[^\]]*\].*?\[/cc\1\])(\s*)#sie', 'PerformProtectComment(\'\\2\', $data, \'\\1\', \'\\3\');', $data);
 // $data = preg_replace('#(\s*)(\<code.*?\>.*?\</code\>)(\s*)#sie', 'PerformProtectComment(\'\\2\', $data, \'\\1\', \'\\3\');', $data);

  if( preg_match( '/<code/', $data, $m ) ){
   file_put_contents( $filename, $data );
  }
}

  function PerformHighlightCodeBlock($text, $opts, $content, $suffix = '', $before = '', $after = '') {
    // Preprocess source text
    $text = str_replace(array("\\\"", "\\\'"), array ("\"", "\'"), $text);
    $text = preg_replace('/(< \?php)/i', '<?php', $text);
    $text = preg_replace('/(?:^(?:\s*[\r\n])+|\s+$)/', '', $text);

    $text = html_entity_decode($text, ENT_QUOTES);
    $text = preg_replace('~&#x0*([0-9a-f]+);~ei', 'chr(hexdec("\\1"))', $text);
    $text = preg_replace('~&#0*([0-9]+);~e', 'chr(\\1)', $text);
    
    $result = '';
    $result = '<pre><code>' . $text . '</pre></code>';

    return $result;
  }
  
  function GetBlockID($content, $comment = false, $before = '<div>', $after = '</div>') {
    static $num = 0;

    $block = $comment ? 'COMMENT' : 'BLOCK';
    $before = $before . '::CODECOLORER_' . $block . '_';
    $after = '::' . $after;

    // Just do a check to make sure the user
    // hasn't (however unlikely) input block replacements
    // as legit text
    do {
      ++$num;
      $blockID = $before . $num . $after;
    } while (strpos($content, $blockID) !== false);

    return $blockID;
  }

  function PerformProtectComment($text, $content, $before, $after) {
    global $comments;

    $text = str_replace(array("\\\"", "\\\'"), array ("\"", "\'"), $text);

    //$blockID = GetBlockID($content, true, '', '');
    //$comments[$blockID] = $text;

    return $after;
  }
?>
