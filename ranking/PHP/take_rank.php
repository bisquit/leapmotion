<?php

  //データベースに接続する変数名を宣言
  define( 'DB_HOST', 'localhost' );
  define( 'DB_USER', 'root' );
  define( 'DB_PASS', '' );
  define( 'DB_NAME', 'score_rank_test' );

  //データベースに接続する
  $db_link = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

  mysqli_set_charset($db_link,"utf8");

  $select = mysqli_query( $db_link, 'SELECT * FROM score_rank ORDER BY score DESC, id DESC LIMIT 0, 3');

  $json = array();
  $data = array();

  while( $row = mysqli_fetch_array( $select ) ){
    $row[0] = mb_convert_encoding($row[0], "UTF-8");
    $row[1] = mb_convert_encoding($row[1], "UTF-8");
    $row[2] = mb_convert_encoding($row[2], "UTF-8");
    $json['id'] = urlencode($row[0]);
    $json['score'] = urlencode($row[1]);
    $json['img_path'] = urlencode($row[2]);
    $data[] = $json;
  }

  echo "result_arr=" . urldecode(json_encode($data));

  mysqli_close($db_link);

?>