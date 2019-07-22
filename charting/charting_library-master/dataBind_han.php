<?php

include_once('./dbconnect.php');

/***
interval : 1m, 3m, 5m, 15m, 30m, 60m(1h), day, week, month

[ market ] : coin
[ BTC ] : ETH / BCH / LTC / ETC
[ ETH ] : BCH / LTC / ETC
[ USDT ]: BTC / ETH / BCH / LTC / ETC
[ KRW ] : BTC / ETH / BCH / LTC / ETC

[ bittrex 데이터 ] 12개코인데이터 3분각격 실행 일 약5800건
[ upbit 데이터 ] 5개코인데이터 3분간격 실행 일 약1800건
b_buy_coin : market		coin_type : coin

b_rgdatetime(실행일) b_maiddatetime(외부데이터체결일)
KRW 마켓데이터를 받아오는 upbit의 경우 b_maiddatetime 15분간격의 데이터를 제공하므로 쿼리문 조회시 b_maiddatetime 을 기준으로 해야하나 이경우
chart interval 을 15분 이하로 설정시 해당 데이터 부재로 15분 interval 차트가 보여질수 있음..
이를 보정하기 위해 krw마켓의 경우 3분간격의 b_rgdatetime 를 사용.
***/

/***  외부테이터 사용 유무 설정값  ***/
$query = "SELECT c_tradebot_use from mari_config";
$result = mysql_query($query);
$config = mysql_fetch_array($result);


$startDay = date("Y-m-d H:i:s", $_REQUEST['from']);
$endDay = date("Y-m-d H:i:s", $_REQUEST['to']);
$symbol = explode('/', $_REQUEST['symbol']);

$market = strtolower($symbol[1]);
$coin = strtolower($symbol[0]);

if(strtolower($symbol[1]) == "krw"){
	$searchdate = "b_rgdatetime";
}else{
	$searchdate = "b_maiddatetime";
}



switch ($_REQUEST['resolution']) {
	case '1':
		$chart_interval = " GROUP BY DATE_FORMAT({$searchdate}, '%Y-%m-%d %H'), FLOOR(MINUTE({$searchdate})/1);";
		break;
	case '3':
		$chart_interval = " GROUP BY DATE_FORMAT({$searchdate}, '%Y-%m-%d %H'), FLOOR(MINUTE({$searchdate})/3);";
		break;
	case '5':
		$chart_interval = " GROUP BY DATE_FORMAT({$searchdate}, '%Y-%m-%d %H'), FLOOR(MINUTE({$searchdate})/5);";
		break;
	case '15':
		$chart_interval = " GROUP BY DATE_FORMAT({$searchdate}, '%Y-%m-%d %H'), FLOOR(MINUTE({$searchdate})/15);";
		break;
	case '30':
		$chart_interval = " GROUP BY DATE_FORMAT({$searchdate}, '%Y-%m-%d %H'), FLOOR(MINUTE({$searchdate})/30);";
		break;
	case 'D':
		$chart_interval = " GROUP BY DATE_FORMAT({$searchdate}, '%Y-%m-%d');";
		break;
	case 'W':
		$chart_interval = " GROUP BY WEEK(DATE_FORMAT({$searchdate}, '%Y-%m-%d'));";
		break;
	case 'M':
		$chart_interval = " GROUP BY MONTH(DATE_FORMAT({$searchdate}, '%Y-%m-%d'));";
		break;
	default:
		$chart_interval = " GROUP BY DATE_FORMAT({$searchdate}, '%Y-%m-%d %H'), FLOOR(MINUTE({$searchdate})/60);";
		break;

}

//b_rgdatetime(실행일) b_maiddatetime(외부데이터체결일)

$sql = "SELECT {$searchdate} AS rowdatetime,
		MID(MIN(CONCAT(DATE_FORMAT({$searchdate}, '%Y%m%d%H%i%s'), baseprice)),LENGTH(DATE_FORMAT({$searchdate}, '%Y%m%d%H%i%s'))+1) AS openprice,
		CONCAT(MAX(baseprice)) AS highprice,
		CONCAT(MIN(baseprice)) AS lowprice,
		MID(MAX(CONCAT(DATE_FORMAT({$searchdate}, '%Y%m%d%H%i%s'), baseprice)), LENGTH(DATE_FORMAT({$searchdate}, '%Y%m%d%H%i%s'))+1) AS closeprice,
		FLOOR(SUM(b_coin)) AS volume
		FROM ( ";
	if($config['c_tradebot_use'] == "Y" && $coin != "koda") {
	$sql .= "SELECT {$searchdate}, b_coin, tradeprice, IF(baseprice = 0, (tradeprice/b_coin), baseprice) AS baseprice, coin_type, b_buy_coin
				FROM mari_tradebot
				WHERE coin_type= '".$coin."' AND b_buy_coin= '".$market."'
				UNION ALL
				SELECT {$searchdate}, (b_coin/2) AS b_coin, tradeprice, baseprice, coin_type, b_buy_coin
				FROM (
					SELECT {$searchdate}, b_coin, tradeprice, baseprice, coin_type, b_buy_coin
					FROM mari_btc_sell_order
					WHERE b_conclusion_use = 'Y' AND coin_type= '".$coin."' AND b_buy_coin= '".$market."'
					UNION ALL
					SELECT {$searchdate}, b_coin, tradeprice, baseprice, coin_type, b_buy_coin
					FROM mari_btc_buying_order
					WHERE b_conclusion_use = 'Y' AND coin_type= '".$coin."' AND b_buy_coin= '".$market."'
				) AS SUB_MARI
		) AS TB
		WHERE {$searchdate} BETWEEN '".$startDay."' AND '".$endDay."'";
	}else{
	$sql .=	"SELECT {$searchdate}, (b_coin/2) AS b_coin, tradeprice, baseprice, coin_type, b_buy_coin
				FROM (
					SELECT {$searchdate}, b_coin, tradeprice, baseprice, coin_type, b_buy_coin
					FROM mari_btc_sell_order
					WHERE b_conclusion_use = 'Y' AND coin_type= '".$coin."' AND b_buy_coin= '".$market."'
					UNION ALL
					SELECT {$searchdate}, b_coin, tradeprice, baseprice, coin_type, b_buy_coin
					FROM mari_btc_buying_order
					WHERE b_conclusion_use = 'Y' AND coin_type= '".$coin."' AND b_buy_coin= '".$market."'
				) AS SUB_MARI
		) AS TB
		WHERE {$searchdate} BETWEEN '".$startDay."' AND '".$endDay."'";
	}


$sql .= $chart_interval;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


$list = array();
$rst = mysql_query($sql);
$data_cnt = mysql_num_rows($rst);

if($data_cnt > 0) {

		$list["s"] = "ok";
		$list["t"] = array(); // 시간
		$list["c"] = array(); // 종가
		$list["o"] = array(); // 시작가
		$list["h"] = array(); // 고가
		$list["l"] = array(); // 저가
		$list["v"] = array(); // 거래량

		while ($row = mysql_fetch_array($rst)) {
			array_push($list["t"], strtotime($row["rowdatetime"]));
			array_push($list["c"], (double)$row["closeprice"]);//(double)
			array_push($list["o"], (double)$row["openprice"]);//(double)
			array_push($list["h"], (double)$row["highprice"]);//(double)
			array_push($list["l"], (double)$row["lowprice"]);//(double)
			array_push($list["v"], (int)$row["volume"]);
		}
}else{
		$list["s"] = "no_data";
		//$list["nextTime"] = mktime($nextTime);

}

echo json_encode($list);