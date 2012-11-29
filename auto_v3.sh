#!/bin/bash
#輸入下載時間
echo "輸入要下載日誌的時間（時間不能跨月）"
echo -n "開始時間(mmdd):"
read date_start
echo -n "結束時間(mmdd):"
read date_end
echo "輸入要下載的日誌類型"
echo "1.軟件頻道"
echo "2.市場下載分析"
echo "3.新版市場分析"
echo "－－－－－－"
echo "4.遊戲頻道"
echo "5.鋒潮數據"
read typed
#echo -n '需要自動速導入到MySQL？要(Y)不要(N):'
#read importswitch
#if [[ "${importswitch^^}" = "Y" ]];then
#	echo -n "輸入MySQL口令:"
#	stty -echo
#	read mysqlpwd
#	stty echo
#fi
mon=${date_start:0:2}
declare -i date_s
date_s=${date_start:2:2}
#declare -i date_e
date_e=${date_end:2:2}
##分解月日方便循環處理文件名

##############下載和解壓模塊######################

case $typed in
	1)
		for (( d = $date_s;d <= $date_e;d++ ));do
			for server in 190 229;do
				zero=
				if [ "$d" -lt "10" ];then zero=0;fi;
				echo "正在下載${server}號服務器日誌"
				axel -a http://192.168.0.251/accesslog/2012${mon}${zero}${d}/iislog-S3GD-${server}-2012${mon}${zero}${d}-gz.rar |tee -a download_${server}_`date +%Y%m%d`.log #下載日誌壓縮包
				echo "${server}號服務器日誌下載完成"
			done
		done
		for (( d = $date_s;d <= $date_e;d++ ));do
			for server in 190 229;do
				[ ! -d "$server" ] && mkdir $server #如果以服務器命名的文件夾不存在，就新建一個，下一步就將日誌解壓到這個文件夾中
				zero=
				if [ "$d" -lt "10" ];then zero=0;fi;
				echo "正在解壓${server}號服務器日誌"
				rar e iislog-S3GD-${server}-2012${mon}${zero}${d}-gz.rar log/iislog/soft.3g.cn/* $server/  |tee -a extract_${server}_`date +%Y%m%d`.log ##解壓軟件服務器的日誌
				echo "${server}號服務器日誌解壓完成"
			done
		done
	;;
	2 | 3)
		for (( d=$date_s;d<=$date_e;d++ ));do
			for server in 0119 0378 0185;do
				zero=
				if [ "$d" -lt "10" ];then zero=0;fi;
				echo "正在下載${server}號服務器日誌"
				axel -a http://192.168.0.251/accesslog/2012${mon}${zero}${d}/iislog-IS13084905-${server}-2012${mon}${zero}${d}-gz.rar  |tee -a download_${server}_`date +%Y%m%d`.log 
				echo "${server}號服務器日誌下載完成"
			done
		done
		for (( d=$date_s;d<=$date_e;d++ ));do
			for server in 0119 0378 0185;do
				[ ! -d "$server" ] && mkdir $server #如果以服務器命名的文件夾不存在，就新建一個，下一步就將日誌解壓到這個文件夾中
				zero=
				if [ "$d" -lt "10" ];then zero=0;fi;
				echo "正在解壓${server}號服務器日誌"
				rar e iislog-IS13084905-${server}-2012${mon}${zero}${d}-gz.rar log/iislog/androidapp.3g.cn/* $server/  |tee -a extract_${server}_`date +%Y%m%d`.log ##下載並解壓市場服務器的日誌
				echo "${server}號服務器日誌解壓完成"
			done
		done
	;;
	4)
		for (( d=$date_s;d<=$date_e;d++ ));do
			for server in 231 269;do
				zero=
				if [ "$d" -lt "10" ];then zero=0;fi;
				echo "正在下載${server}號服務器日誌"
				axel -a http://192.168.0.251/accesslog/2012${mon}${zero}${d}/iislog-S3GD-${server}-2012${mon}${zero}${d}-gz.rar  |tee -a download_${server}_`date +%Y%m%d`.log 
				echo "${server}號服務器日誌下載完成"
			done
		done
		for (( d=$date_s;d<=$date_e;d++ ));do
			for server in 231 269;do
				[ ! -d "$server" ] && mkdir $server #如果以服務器命名的文件夾不存在，就新建一個，下一步就將日誌解壓到這個文件夾中
				zero=
				if [ "$d" -lt "10" ];then zero=0;fi;
				echo "正在解壓${server}號服務器日誌"
				rar e iislog-S3GD-${server}-2012${mon}${zero}${d}-gz.rar log/iislog/soft.3g.cn/*  |tee -a extract_${server}_`date +%Y%m%d`.log ##下載並解壓遊戲服務器的日誌
				echo "${server}號服務器日誌解壓完成"
			done
		done
	;;
#	5)
#		for (( d=$date_s;d<=$date_e;d++ ));do
#			zero=
#			if [ "$d" -lt "10" ];then zero=0;fi;
#			echo "正在下載${server}號服務器日誌"
#			axel -a http://192.168.0.251/accesslog/2012${mon}${zero}${d}/iislog-IS13084905-0092-2012${mon}${zero}${d}-gz.rar  |tee -a download_${server}_`date +%Y%m%d`.log 
#			echo "${server}號服務器日誌下載完成"
#		done
#		for (( d=$date_s;d<=$date_e;d++ ));do
#			[ ! -d "$server" ] && mkdir $server #如果以服務器命名的文件夾不存在，就新建一個，下一步就將日誌解壓到這個文件夾中
#			zero=
#			if [ "$d" -lt "10" ];then zero=0;fi;
#			echo "正在解壓${server}號服務器日誌"
#			rar e iislog-IS13084905-0092-2012${mon}${zero}${d}-gz.rar log/iislog/talkphone.cn/* log/iislog/www.talkphone.cn/* |tee -a extract_${server}_`date +%Y%m%d`.log 
#				echo "${server}號服務器日誌解壓完成"
#		done
#	;;
	*)
		echo "鋒潮網的分析因為忘了awk所以暫不開放。如果是輸入錯誤，就重新來吧"
		read
		break
	;;
	
esac

###################下面是awk預處理#######################
echo "下面要awk了，慢慢等吧...."
zero_s=
[ $date_s -lt "10" ] && zero_s=0
zero_e=
[ $date_e -lt "10" ] && zero_e=0
##繼續處理零的佔位問題
case $typed in
	1)
		awk '$4~/download.php/&&$0!~/[Gg]oogle[Bb]ot/&&$0!~/[Bb]aidu[Ss]pider/&&$0!~/[Rr]obot/{a[$4" "$5" "$10" "$1" "substr($2,1,2)" "$7" "$9]++}END{for(b in a){print b" "a[b]>>"awk.out"}}' 190/*.log 229/*.log
		outputname=${mon}${zero_s}${date_s}_${mon}${zero_e}${date_e}_softdown_`date +%Y%m%d`

	;;
	2)
		awk '$4=="/v3/json.aspx"&&($5~/requestCommandType=19/||$5~/requestCommandType=147/)&&$0!~/[Gg]oogle[Bb]ot/&&$0!~/[Bb]aidu[Ss]pider/&&$0!~/[Rr]obot/{a[$4" "$5" "$10" "$1" "substr($2,1,2)" "$7" "$9]++}END{for(b in a){print b" "a[b]>>"awk.out"}}' 0119/*.log 0185/*.log 0378/*.log
		outputname=${mon}${zero_s}${date_s}_${mon}${zero_e}${date_e}_marketdown_`date +%Y%m%d`
	;;
	3)
		 awk '$4=="/v3/json.aspx"&&$0!~/[Gg]oogle[Bb]ot/&&$0!~/[Bb]aidu[Ss]pider/&&$0!~/[Rr]obot/{a[$4" "$5" "$10" "$1" "substr($2,1,2)" "$7" "$9]++}END{for(b in a){print b" "a[b]>>"awk.out"}}' 0119/*.log 0185/*.log 0378/*.log
		outputname=${mon}${zero_s}${date_s}_${mon}${zero_e}${date_e}_newversion_`date +%Y%m%d`
	;;
	4)
		awk '$4~/download.php/&&$0!~/[Gg]oogle[Bb]ot/&&$0!~/[Bb]aidu[Ss]pider/&&$0!~/[Rr]obot/{a[$4" "$5" "$10" "$1" "substr($2,1,2)" "$7" "$9]++}END{for(b in a){print b" "a[b]>>"awk.out"}}' 231/*.log 269/*.log
		outputname=${mon}${zero_s}${date_s}_${mon}${zero_e}${date_e}_gamedown_`date +%Y%m%d`
	;;
#	5)
#		awk 'do sth'為鋒潮網預留
#		outputname=${mon}${zero_s}${date_s}_${mon}${zero_e}${date_e}_talkphone_`date +%Y%m%d`
#	;;
esac
mv awk.out $outputname
echo "搞掂！"
############將預處理過的文件導入到MySQL#################
#[ "${importswitch^^}" != Y ] && exit
#echo "開始導入到MySQL"
#tablename=${outputname:10:100}
#mysql -uroot -p${mysqlpwd} ana -e"
#create table $tablename (
#page char(100),
#url text,
#status char(3),
#csdate date,
#cstime int(1),
#ip char(15),
#refer text,
#cnt int(11));
#"
#mysql -uroot --localinfile -p${mysqlpwd} ana -e"
#load data local infile '$outputname'
#into table $tablename fields terminated by ' ';
#"
#[ "$typed"!="4" ] && mysql -uroot -p${mysqlpwd} ana -e"
#create table ${tablename}_mod
#SELECT url,
#case when locate('typelist',url)=0 or locate('typelist=&',url)<>0 then ''
#else replace(SUBSTRING(url,locate('typelist',url)+9,2),'&','') end urltypelist,
#case when locate('recommandid',url)=0 or locate('recommandid=&',url)<>0 then ''
#else replace(SUBSTRING(url,locate('recommandid',url)+12,6),'&','') end urlreid,
#case when locate('&d',url)=0 or locate('d=&',url)<>0 then ''
#else replace(substring(url,locate('&d',url)+2,2),'&','') end urld,
#case when locate('cooid',url)=0 or locate('cooid=&',url)<>0 then ''
#else replace(substring(url,locate('cooid',url)+6,4),'&','') end urlcooid,
#case when locate('sysid',url)=0 or locate('sysid=&',url)<>0 then ''
#else replace(substring(url,locate('sysid',url)+6,3),'&','') end urlsysid,
#case when locate('fid',url)=0 or locate('fid=&',url)<>0 then ''
#else replace(substring(url,locate('fid',url)+4,6),'&','') end urlfid,
#case when locate('cin',url)=0 or locate('cin=&',url)<>0 then ''
#else replace(substring(url,locate('cin',url)+4,4),'&','') end urlcin,
#refer,
#case when locate('.3g.cn',refer)=0 then refer
#else LEFT(refer,locate('.3g.cn',refer)+6) end referdomain,
#case when locate('?',refer)=0 then refer
#else left(refer,locate('?',refer)-1) end referurl,
#case when locate('typelist',refer)=0 then ''
#else replace(SUBSTRING(refer,locate('typelist',refer),11),'&','') end refertypelist,
#case when locate('recommandid',refer)=0 then ''
#else replace(SUBSTRING(refer,locate('recommandid',refer),18),'&','') end referreid,
#case when locate('&d',refer)=0 then ''
#else replace(substring(refer,locate('&d',refer)+1,4),'&','') end referd,
#case when locate('cooid',refer)=0 then ''
#else replace(substring(refer,locate('cooid',refer),10),'&','') end refercooid,
#case when locate('cin',refer)=0 then ''
#else replace(substring(refer,locate('cin',refer),9),'&','') end refercin,
#page,status,ip,cnt,case when cstime+8>=24 then cstime+8-24 else cstime+8 end timecr,
#                         case when cstime+8>=24 then date_format(csdate+1,'%Y-%m-%d')
#                              else date_format(csdate,'%Y-%m-%d') end datecr
#from ${tablename}
#" && echo "done!"
#[ "$typed"="4" ] && mysql -uroot -p${mysqlpwd} ana -e"
#create table ${tablename}_mod
#SELECT url,
#case when locate('typelist',url)=0 or locate('typelist=&',url)<>0 then ''
#else replace(SUBSTRING(url,locate('typelist',url)+9,2),'&','') end urltypelist,
#case when locate('recommandid',url)=0 or locate('recommandid=&',url)<>0 then ''
#else replace(SUBSTRING(url,locate('recommandid',url)+12,6),'&','') end urlreid,
#case when locate('&d',url)=0 or locate('d=&',url)<>0 then ''
#else replace(substring(url,locate('&d',url)+2,2),'&','') end urld,
#case when locate('cooid',url)=0 or locate('cooid=&',url)<>0 then ''
#else replace(substring(url,locate('cooid',url)+6,4),'&','') end urlcooid,
#case when locate('sysid',url)=0 or locate('sysid=&',url)<>0 then ''
#else replace(substring(url,locate('sysid',url)+6,3),'&','') end urlsysid,
#case when locate('gid',url)=0 or locate('gid=&',url)<>0 then ''
#else replace(substring(url,locate('gid',url)+4,7),'&','') end urlgid,
#case when locate('cin',url)=0 or locate('cin=&',url)<>0 then ''
#else replace(substring(url,locate('cin',url)+4,4),'&','') end urlcin,
#refer,
#case when locate('.3g.cn',refer)=0 then refer
#else LEFT(refer,locate('.3g.cn',refer)+6) end referdomain,
#case when locate('?',refer)=0 then refer
#else left(refer,locate('?',refer)-1) end referurl,
#case when locate('typelist',refer)=0 then ''
#else replace(SUBSTRING(refer,locate('typelist',refer),11),'&','') end refertypelist,
#case when locate('recommandid',refer)=0 then ''
#else replace(SUBSTRING(refer,locate('recommandid',refer),18),'&','') end referreid,
#case when locate('&d',refer)=0 then ''
#else replace(substring(refer,locate('&d',refer)+1,4),'&','') end referd,
#case when locate('cooid',refer)=0 then ''
#else replace(substring(refer,locate('cooid',refer),10),'&','') end refercooid,
#case when locate('cin',refer)=0 then ''
#else replace(substring(refer,locate('cin',refer),9),'&','') end refercin,
#page,status,ip,cnt,case when cstime+8>=24 then cstime+8-24 else cstime+8 end timecr,
#                         case when cstime+8>=24 then date_format(csdate+1,'%Y-%m-%d')
#                              else date_format(csdate,'%Y-%m-%d') end datecr
#from ${tablename}
#" && echo "done!"
echo "全部都搞掂喇！！！！"
