#!/bin/sh
#删除旧配置
sed -i '/freenom/d' /var/spool/cron/crontabs/root
#增加配置
echo "$CRON cd /freenom/ && php run > freenom_crontab.log 2>&1">>/var/spool/cron/crontabs/root
# 如果两个配置文件不存在，从备份中复制一波到数据卷中
if [ ! -f /freenom/config.php ]; then
	cp /confbak/config.php /freenom/config.php
fi
if [ ! -f /freenom/.env ]; then
	cp /confbak/.env /freenom/.env
	if [[ ("${FREENOM_USERNAME}" == '' || "${FREENOM_PASSWORD}" == '') && "${MULTIPLE_ACCOUNTS}" == '' ]]; then echo '你在 Github 的当前项目的 Settings > Secrets 画面没有设置任何与账户信息相关的 secret 值，无法正常运行，请添加新的 secret 值，设置 FREENOM_USERNAME 与 FREENOM_PASSWORD，或者设置 MULTIPLE_ACCOUNTS，以及 .env 文件中其它必要项，各项的具体含义与格式参考本项目 .env 文件中的说明。'; fi
	if [ "${FREENOM_USERNAME}" != '' ]; then sed -i "s/^FREENOM_USERNAME=.*$/FREENOM_USERNAME='${FREENOM_USERNAME}'/" /freenom/.env; fi
	if [ "${FREENOM_PASSWORD}" != '' ]; then sed -i "s/^FREENOM_PASSWORD=.*$/FREENOM_PASSWORD='${FREENOM_PASSWORD}'/" /freenom/.env; fi
	if [ "${MULTIPLE_ACCOUNTS}" != '' ]; then sed -i "s/^MULTIPLE_ACCOUNTS=.*$/MULTIPLE_ACCOUNTS='${MULTIPLE_ACCOUNTS}'/" /freenom/.env; fi
	if [ "${MAIL_USERNAME}" != '' ]; then sed -i "s/^MAIL_USERNAME=.*$/MAIL_USERNAME='${MAIL_USERNAME}'/" /freenom/.env; fi
	if [ "${MAIL_PASSWORD}" != '' ]; then sed -i "s/^MAIL_PASSWORD=.*$/MAIL_PASSWORD='${MAIL_PASSWORD}'/" /freenom/.env; fi
	if [ "${TO}" != '' ]; then sed -i "s/^TO=.*$/TO='${TO}'/" /freenom/.env; fi
	if [ "${MAIL_ENABLE}" != '' ]; then sed -i "s/^MAIL_ENABLE=.*$/MAIL_ENABLE='${MAIL_ENABLE}'/" /freenom/.env; fi
	if [ "${TELEGRAM_CHAT_ID}" != '' ]; then sed -i "s/^TELEGRAM_CHAT_ID=.*$/TELEGRAM_CHAT_ID='${TELEGRAM_CHAT_ID}'/" /freenom/.env; fi
	if [ "${TELEGRAM_BOT_TOKEN}" != '' ]; then sed -i "s/^TELEGRAM_BOT_TOKEN=.*$/TELEGRAM_BOT_TOKEN='${TELEGRAM_BOT_TOKEN}'/" /freenom/.env; fi
	if [ "${TELEGRAM_BOT_ENABLE}" != '' ]; then sed -i "s/^TELEGRAM_BOT_ENABLE=.*$/TELEGRAM_BOT_ENABLE='${TELEGRAM_BOT_ENABLE}'/" /freenom/.env; fi
	if [ "${NOTICE_FREQ}" != '' ]; then sed -i "s/^NOTICE_FREQ=.*$/NOTICE_FREQ='${NOTICE_FREQ}'/" /freenom/.env; fi
	sed -i "s/^ON_GITHUB_ACTIONS=.*$/ON_GITHUB_ACTIONS=true/" /freenom/.env
fi
# # 下面是软连接，源-目标，如果实际没有那么创建软连接
# if [ ! -f /freenom/config.php ]; then
# 	ln -s /conf/config.php /freenom/config.php
# fi
# if [ ! -f /freenom/.env ]; then
# 	ln -s /conf/.env /freenom/.env
# fi
cd /freenom/
php run
crond -f
#防止sh执行完自动退出，可以用crond -f 前台运行解决
#php -a
