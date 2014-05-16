<?php

  //データベースに接続する変数名を宣言
  define( 'DB_HOST', 'localhost' );
  define( 'DB_USER', 'root' );
  define( 'DB_PASS', '' );
  define( 'DB_NAME', 'score_rank_test' );

  //データベースに接続する
  $db_link = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

  mysqli_set_charset($db_link,"utf8");

  // idの取得
  $select_id = mysqli_query( $db_link, 'SELECT id FROM score_rank WHERE img_path = ""');
  $select_row = mysqli_fetch_assoc($select_id);

  // 画像の保存
  $file_name = "id_" . sprintf("%04d", $select_row['id']) . ".jpg";
  $file = fopen('./img/' . $file_name, 'wb');
  fwrite($file, $GLOBALS['HTTP_RAW_POST_DATA']);
  fclose($file);

  // 画像のパスをDBに格納
  $replace_path = mysqli_query( $db_link, 'UPDATE score_rank SET img_path = "http://localhost/ScoreRanking/img/' . $file_name . '" WHERE img_path = ""');

  mysqli_close($db_link);

?>