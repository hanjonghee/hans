

1.charting_library-master 폴더는 original 원본 소스



2.원본소스에서 수정하거나 추가된 파일 ( kodaex 예시 )


	[ datafeed2.js ]
	실제 구동파일
	환경파일들을 참조하여 실제 실행되는 파일
	datafeed.js 파일을 환경에 맞게 수정

	Datafeeds.UDFCompatibleDatafeed 함수의 _barsPulseUpdater 값은 차트데이터 업데이트 반영시간입니다.초단위
	적절한 시간으로 적용	( 180 * 1000 : 180초 )

	[ datafeed_config.php ]
	전체환경파일

	[ dataBind_han.php ]
	data 파일

	[ symbols.php ]
	coin_market 별 개별환경파일
	pricescale 항목 1값은 정수 10/100/1000......부터는 실수 소수점자리수를 표현


3.charting_library-master\charting_library 의 index.html

	client_id / user_id / datafeed / library_path 설정
	차트 UI부분 수정가능



