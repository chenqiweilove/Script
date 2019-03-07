#!/usr/bin/env python
# -*- coding: utf-8 -*-
##zabbix sms alertscripts
import sys
from aliyunsdkdysmsapi.request.v20170525 import SendSmsRequest
from aliyunsdkdysmsapi.request.v20170525 import QuerySendDetailsRequest
from aliyunsdkcore.client import AcsClient
import uuid
from aliyunsdkcore.profile import region_provider
from aliyunsdkcore.http import method_type as MT
from aliyunsdkcore.http import format_type as FT
import json
import datetime
"""
短信业务调用接口示例，版本号：v20170525

Created on 2017-06-12

"""
try:
    reload(sys)
    sys.setdefaultencoding('utf8')
except NameError:
    pass
except Exception as err:
    raise err

# 注意：不要更改
REGION = "cn-hangzhou"
PRODUCT_NAME = "Dysmsapi"
DOMAIN = "dysmsapi.aliyuncs.com"

ACCESS_KEY_ID = "xxxx"
ACCESS_KEY_SECRET = "xxxx"
now_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
acs_client = AcsClient(ACCESS_KEY_ID, ACCESS_KEY_SECRET, REGION)
region_provider.add_endpoint(PRODUCT_NAME, REGION, DOMAIN)


def send_sms(business_id, phone_numbers, sign_name, template_code, template_param=None):
    smsRequest = SendSmsRequest.SendSmsRequest()
    # 申请的短信模板编码,必填
    smsRequest.set_TemplateCode(template_code)

    # 短信模板变量参数
    if template_param is not None:
        smsRequest.set_TemplateParam(template_param)

    # 设置业务请求流水号，必填。
    smsRequest.set_OutId(business_id)

    # 短信签名
    smsRequest.set_SignName(sign_name)

    # 数据提交方式
    # smsRequest.set_method(MT.POST)

    # 数据提交格式
    # smsRequest.set_accept_format(FT.JSON)

    # 短信发送的号码列表，必填。
    smsRequest.set_PhoneNumbers(phone_numbers)

    # 调用短信发送接口，返回json
    smsResponse = acs_client.do_action_with_exception(smsRequest)

    # TODO 业务处理

    return smsResponse

if __name__ == '__main__':
    __business_id = uuid.uuid1()
    phone_numbers = sys.argv[1]
    sign_name = "XXXX"
    template_code = "sms_142387321"
    zabbix_hostname = 'sun{0} {1}'.format(str(sys.argv[2]).split()[0][-1],str(sys.argv[2]).split()[1]) 
    ##zabbix传送数据分隔符设置为#,短信模板字数不超过20个，所以只发送前20个字符。
    zabbix_message = str(sys.argv[3]).split("#")
    template_param = {
        "host": zabbix_hostname,
        "module": zabbix_message[0][:20],
        "content": zabbix_message[1][:20]
    }
    params = json.dumps(template_param)
    respond = send_sms(__business_id, phone_numbers, sign_name, template_code, params).decode("utf8")
    with open("/var/log/zabbix/out.txt", "a") as f:
    	f.writelines('{0} {1}\n'.format(now_time,respond))
