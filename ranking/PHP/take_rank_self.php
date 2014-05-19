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
  $select_id = mysqli_query( $db_link, 'SELECT id FROM score_rank ORDER BY id DESC LIMIT 0, 1');
  $select_row = mysqli_fetch_assoc($select_id);

  // 順位の取得
  $select_rank = mysqli_query( $db_link, 'SELECT *, (SELECT COUNT(*) FROM score_rank b WHERE a.score < b.score) + 1 AS rank FROM score_rank a WHERE id='.$select_row['id'].' ORDER BY score DESC');
  $rank_row = mysqli_fetch_assoc($select_rank);
  $rank = $rank_row['rank'];

  echo "rank=" . $rank;

?>