<?php

  //データベースに接続する変数名を宣言
  define( 'DB_HOST', 'localhost' );
  define( 'DB_USER', 'root' );
  define( 'DB_PASS', '' );
  define( 'DB_NAME', 'score_rank_test' );

  // ASから変数を受け取る
  $score = $_POST['score'];

  //データベースに接続する
  $db_link = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

  mysqli_set_charset($db_link,"utf8");

  $insert_score = mysqli_query( $db_link, 'INSERT INTO score_rank (score, img_path) VALUES ( '.$score.', "" )');

  mysqli_close($db_link);

?>