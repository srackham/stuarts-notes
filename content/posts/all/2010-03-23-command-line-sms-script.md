---
date: 2010-03-23 03:11:39+00:00
slug: command-line-sms-script
title: Command-line SMS script
tags:
- clickatell
- commandline
- python
- sms
---




**_Note_**:
The [current version of this app](/posts/coffeescript-for-command-line-apps/) is written in CoffeeScript and is published in the npm package registry.


A simple Python command-line script I wrote to send SMS messages using [Clickatell's](http://clickatell.com/) HTTP API. In addition it:

  * Records sent messages in a log and has command option to view log file. 
  * Has command options to query the Clickatell account balance and the status of previously sent messages. 
  * Configuration can include a list of phone numbers.

<!--more-->


## Example usage



    $ python sms.py 64912345667 "Hello World"
    ID: 26a8147fa04ed9fj2a9ad125c55cee00
    
    $ sms.py -s 26a8147fa04ed9fj2a9ad125c55cee00
    apiMsgId: 26a8147fa04ed9fj2a9ad125c55cee00 charge: 0.8 status: 004
    (received by recipient)
    
    $ python sms.py -b
    Credit: 204.900
    
    $ python sms.py --help
    
    NAME
        sms.py - Send SMS message
    
    SYNOPSIS
        sms.py PHONE MESSAGE
        sms.py -s MSGID
        sms.py -b | -l
    
    DESCRIPTION
        A simple Python command-line script to send SMS messages using
        Clickatell's HTTP API (see http://clickatell.com).
        Records messages log in /home/srackham/sms.log
        Reads configuration parameters from /home/srackham/.sms.conf
    
    OPTIONS
        -s MSGID
            Query message delivery status.
    
        -b
            Query account balance.
    
        -l
            List message log file using /usr/bin/less.
    
        -p
            List phone book.
    
    AUTHOR
        Written by Stuart Rackham, 
    
    COPYING
        Copyright (C) 2010 Stuart Rackham. Free use of this software is
        granted under the terms of the MIT License.


 


### Configuration

Set the Clickatell account configuration parameters in the `sms.py` script or put them in a JSON format file named `.sms.conf` in your home directory. For example:



    
``` python    
    {
      "USERNAME":  "foobar",
      "PASSWORD":  "secret",
      "API_ID":    "123456",
      "SENDER_ID": "+64912345678",
      "PHONE_BOOK": {
        "tom":   "+64 21 1234 5678",
        "dick":  "+61 25 1234 567",
        "harry": "+64 9 1234 346"
      }
    }
```

 


### sms.py source code

``` python
#!/usr/bin/env python

# A simple Python command-line script to send SMS messages using
# Clickatell's HTTP API (see http://clickatell.com).

'''
NAME
    %(prog)s - Send SMS message

SYNOPSIS
    %(prog)s PHONE MESSAGE
    %(prog)s -s MSGID
    %(prog)s -b | -l

DESCRIPTION
    A simple Python command-line script to send SMS messages using
    Clickatell's HTTP API (see http://clickatell.com).
    Records messages log in %(log)s
    Reads configuration parameters from %(conf)s

OPTIONS
    -s MSGID
        Query message delivery status.

    -b
        Query account balance.

    -l
        List message log file using %(pager)s.

    -p
        List phone book.

AUTHOR
    Written by Stuart Rackham, <srackham@gmail.com>

COPYING
    Copyright (C) 2010 Stuart Rackham. Free use of this software is
    granted under the terms of the MIT License.
'''
VERSION = '0.2.4'

import urllib
import os, sys, time, re
import simplejson as json

# Clickatell account configuration parameters.
# Create a separate configuration file named `.sms.conf` in your `$HOME`
# directory. The configuration file is single JSON formatted object with the
# same attributes and attribute types as the default CONF variable below.
# Alternatively you could dispense with the configuration file and edit the
# values in the CONF variable below.
CONF = {
    'USERNAME': '',
    'PASSWORD': '',
    'API_ID': '',
    'SENDER_ID': '',  # Your registered mobile phone number.
    'PHONE_BOOK': {},
}


PROG = os.path.basename(__file__)
HOME = os.environ.get('HOME', os.environ.get('HOMEPATH',
       os.path.dirname(os.path.realpath(__file__))))
LOG_FILE = os.path.join(HOME,'sms.log')
CONF_FILE = os.path.join(HOME,'.sms.conf')
if os.path.isfile(CONF_FILE):
    CONF = json.load(open(CONF_FILE))
SENDER_ID = CONF['SENDER_ID']
PHONE_BOOK = CONF['PHONE_BOOK']
PAGER = os.environ.get('PAGER','less')

# URL query string parameters.
QUERY = {'user': CONF['USERNAME'], 'password': CONF['PASSWORD'],
          'api_id': CONF['API_ID'], 'concat': 3}

# Clickatell status messages.
MSG_STATUS = {
    '001': 'message unknown',
    '002': 'message queued',
    '003': 'delivered to gateway',
    '004': 'received by recipient',
    '005': 'error with message',
    '007': 'error delivering message',
    '008': 'OK',
    '009': 'routing error',
    '012': 'out of credit',
}

# Retrieve Clickatell account balance.
def account_balance():
    return http_cmd('getbalance')

# Query the status of a previously sent message.
def message_status(msgid):
    QUERY['apimsgid'] = msgid
    result = http_cmd('getmsgcharge')
    result += ' (' + MSG_STATUS.get(result[-3:],'') + ')'
    return result

# Strip number punctuation and check the number is not obviously illegal.
def sanitize_phone_number(number):
    result = re.sub(r'[+ ()-]', '', number)
    if not re.match(r'^\d+$', result):
        print 'illegal phone number: %s' % number
        exit(1)
    return result

# Send text message. The recipient phone number can be a phone number
# or the name of a phone book entry.
def send_message(text, to):
    if to in PHONE_BOOK:
        name = to
        to = PHONE_BOOK[to]
    else:
        name = None
    to = sanitize_phone_number(to)
    sender_id = sanitize_phone_number(SENDER_ID)
    if sender_id.startswith('64') and to.startswith('6427'):
        # Use local number format if sending to Telecom NZ mobile from a NZ
        # number (to work around Telecom NZ blocking NZ originating messages
        # from Clickatell).
        sender_id = '0' + sender_id[2:]
    QUERY['from'] = sender_id
    QUERY['to'] = to
    QUERY['text'] = text
    result = http_cmd('sendmsg')
    now = time.localtime(time.time())
    if name:
        to += ': ' + name
    print >>open(LOG_FILE, 'a'), \
        'to:     %s\nfrom:   %s\ndate:   %s\nresult: %s\ntext:   %s\n' % \
        (to, sender_id, time.asctime(now), result, text)
    return result

# Execute Clickatell HTTP command.
def http_cmd(cmd):
    url = 'http://api.clickatell.com/http/' + cmd
    query = urllib.urlencode(QUERY)
    file = urllib.urlopen(url, query)
    result = file.read()
    file.close()
    return result

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc == 3:
        if sys.argv[1] == '-s':
            print message_status(sys.argv[2])
        else:
            print send_message(sys.argv[2], sys.argv[1])
    elif argc == 2 and sys.argv[1] == '-b':
        print account_balance()
    elif argc == 2 and sys.argv[1] == '-l': # View log file.
        os.system(PAGER + ' ' + LOG_FILE)
    elif argc == 2 and sys.argv[1] == '-p': # List phone book.
        for i in PHONE_BOOK.items():
            print '%s: %s' % i
    else:
        print __doc__ % {'prog':PROG,'log':LOG_FILE,'conf':CONF_FILE,'pager':PAGER}
```

