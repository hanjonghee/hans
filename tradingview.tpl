<?php

$sellcoin = $_REQUEST['sellcoin'];
$buycoin = $_REQUEST['buycoin'];

?>
<!-- jQuery is not required to use Charting Library. It is used only for sample datafeed ajax requests. -->
<!-- <script type="text/javascript" src="//code.jquery.com/jquery-1.11.2.min.js"></script> -->
<script>window.jQuery || document.write('<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"><\/script>')</script>
<script type="text/javascript" src="{MARI_PLUGIN_URL}/charting/tdview/charting_library/charting_library.min.js"></script>
<script type="text/javascript" src="{MARI_PLUGIN_URL}/charting/tdview/charting_library/datafeed/udf/datafeed2.js?<?=filemtime($_SERVER['DOCUMENT_ROOT'].'/home/plugin/charting/tdview/charting_library/datafeed/udf/datafeed2.js')?>"></script>

<script type="text/javascript">

	/****
            TradingView.onready(function () {
                var widget = loadTradingView("ETC/USDT"); // Default BTC
					widget.onChartReady(function () {
                    widget.chart().createStudy("Moving Average", false, false, [15], function (guid) {},{"plot.color.0" : "orange"});
                    widget.chart().createStudy("Moving Average", false, false, [60], function (guid) {},{"plot.color.0" : "blue"});

                });

            });
        ****/

            function getParameterByName(name) {
                name = name.replace(/[\[]/, "\[").replace(/[\]]/, "\]");
                var regex = new RegExp("[\?&]" + name + "=([^&#]*)"),
                    results = regex.exec(location.search);
                return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
            }

            function loadTradingView(coin) {

		var value = document.cookie.match('(^|;) ?dayNight=([^;]*)(;|$)');
		var dayNight = value? value[2] : null;
		var tvBgColor;
		var marketcoin = coin.split("/");
		var cointype = marketcoin[0].trim();
		var loadinterval;

		if(cointype.match("KODA")) {
			loadinterval = 1;
		}else{
			loadinterval = 15;
		}

		if(dayNight == 'day'){
			tvBgColor = "#FFFFFF";
		}else{
			tvBgColor = "#24252e";
		}

		var widget = window.tvWidget = new TradingView.widget({
                    autosize: true,
		    width: 1044,
		    height: 482,
		    symbol: coin,
                    interval: loadinterval,
                    timezone: "Asia/Seoul",
		    locale: "ko",
	    	    //toolbar_bg: "#24252e",
		    padding: "0",
                    style: "1",
                    container_id: "tv_chart_container",
                    datafeed: new Datafeeds.UDFCompatibleDatafeed("https://kodaex.co.kr"),
                    library_path: "https://kodaex.co.kr/home/plugin/charting/tdview/charting_library/",
                    enable_publishing: false,
                    allow_symbol_change: false,
                    hideideas: true,
		    //hide_top_toolbar: true,
                    //hide_side_toolbar: true,
                    overrides: {
					"mainSeriesProperties.candleStyle.upColor": "#b53333",		//적색
					"mainSeriesProperties.candleStyle.downColor": "#235e23",	//녹색
					"mainSeriesProperties.candleStyle.drawBorder": false,
					"symbolWatermarkProperties.transparency": 90,
					"scalesProperties.textColor": "#6a6d88",			//#666666
					"paneProperties.background": tvBgColor,		//background color
					"paneProperties.vertGridProperties.color": tvBgColor,	//#1d1e25
					"paneProperties.horzGridProperties.color": tvBgColor,
					"volumePaneSize": "medium",
					"MACDPaneSize": "tiny"
                    },
		    studies_overrides: {
			    		"volume.volume.color.0": "#48b451",
					"volume.volume.color.1": "#b54646",
					"volume.volume.transparency": 60,	//투명도
					//"volume.volume ma.color": "#F0FFFF",
					//"volume.volume ma.transparency": 90,
					//"volume.volume ma.linewidth": 5,
					"volume.show ma": false
		    },
		    //time_frames: [
					//{ text: "1m", resolution: "M", description: "1달" },
					//{ text: "1d", resolution: "D", description: "1일" },
					//{ text: "1w", resolution: "W", description: "1주" }
					//{ text: "60m", resolution: "60", description: "60분" },
					//{ text: "30m", resolution: "30", description: "30분" },
					//{ text: "15m", resolution: "15", description: "15분" },
					//{ text: "5m", resolution: "5", description: "5분" },
					//{ text: "3m", resolution: "3", description: "3분" }
				//],
                    //drawings_access: { type: 'black', tools: [{ name: "Regression Trend" }] },
                    disabled_features: ["use_localstorage_for_settings",
		    			"save_chart_properties_to_local_storage",
					"volume_force_overlay",
					"border_around_the_chart",
					"pane_context_menu",
					"header_saveload",
					"header_compare",
					"header_undo_redo",
					"header_symbol_search",
					"symbol_search_hot_key",
					"header_screenshot",
					"timeframes_toolbar",
					"header_resolutions"
					//"header_fullscreen_button",
					//"header_chart_type",
					//"header_indicators",
					//"header_settings",
					//"left_toolbar"
					],
                    enabled_features: ["study_templates", "hide_last_na_study_output"],
		    //enabled_features: ["header_resolutions"],
                    charts_storage_url: 'https://saveload.tradingview.com',
                    charts_storage_api_version: "1.1",
                    client_id: 'jin@intowinsoft.co.kr',
                    user_id: 'intowin'
                });


                widget.onChartReady(function () {
                    //widget.chart().createStudy("Moving Average", false, false, [15], function (guid) {},{"plot.color.0" : "orange"});
                    //widget.chart().createStudy("Moving Average", false, false, [60], function (guid) {},{"plot.color.0" : "blue"});

			widget.createButton().addClass("mydate")
				.attr('title', "1min")
				.append($("<span>1분</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('1',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "3min")
				.append($("<span>3분</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('3',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "5min")
				.append($("<span>5분</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('5',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "15min")
				.append($("<span>15분</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('15',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "30min")
				.append($("<span>30분</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('30',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "60min")
				.append($("<span>시간</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('60',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "day")
				.append($("<span>일</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('D',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "week")
				.append($("<span>주</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('W',
						function onReadyCallback() {
						});
					});
			widget.createButton().addClass("mydate")
				.attr('title', "month")
				.append($("<span>월</span>"))
				.on('click',function (e) {
					    widget.chart().setChartType(1);
					    widget.chart().setResolution('M',
						function onReadyCallback() {
						});
					});

                });


                //return widget;
            }

	    $(document).ready(function(){
		 var coin = '<? echo $sellcoin; ?>';
		 var market = '<? echo $buycoin; ?>';
		 var coinmarket = coin + '/' + market;

		 if(coin == "" && market == ""){
			loadTradingView("KODA/KRW");	//loadTradingView
		 }else{
			loadTradingView(coinmarket);
		 }

	    });

</script>