<?
$symbol = explode('/', $_REQUEST['symbol']);
$market = strtoupper($symbol[1]);
$coin = trim(str_replace('CHART:', '', strtoupper($symbol[0])));

if ( $market == 'KRW' ) $pricescale = 1;
else $pricescale = 1000000;
?>

{
"name": "<?=$coin?>/<?=$market?>",
"exchange-traded":"CHART",
"exchange-listed":"CHART",
"timezone":"Asia/Seoul",
"minmov":1,
"minmov2":0,
"pointvalue":1,
"session":"0930-1730",
"has_intraday":true,
"has_daily":true,
"has_weekly_and_monthly":true,
"has_no_volume":false,
"description":"<?=$coin?>/<?=$market?>",
"type":"bitcoin",
"supported_resolutions":["1", "3", "5", "15", "30", "60", "D", "W", "M"],
"pricescale":<?=$pricescale?>,
"data_status":"streaming",
"ticker":"<?=$coin?>/<?=$market?>"
}