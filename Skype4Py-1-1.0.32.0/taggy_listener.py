#!/usr/bin/env python

import Skype4Py
import time
import simplejson
import urllib

def user_status(Status):
    print 'The status of the user changed to', Status

def message_status(Message, Status):  
    print "Status = ", Status
    if(Status == 'SENDING' or Status == 'RECEIVED'):
        json = TaggyChat(Message).to_json()
        print "JSON = ", json
        fh = urllib.urlopen('http://campzero.com/instant_messages/from_im', str(json))
        print fh.readline()

def print_users(user_collection):
    print "Users count = ", user_collection.Count
    for index in range(user_collection.Count):
        print user_collection.Item(index).Handle
        
class TaggyChat:
    
    def __init__(self, chat_message):
        self.chat_message = chat_message

    def to_json(self):
        at_time = self.chat_message.Datetime.strftime("%I:%M:%S %p")
        from_name = self.chat_message.FromDisplayName
        
        print "From = ", from_name
        print "Project user = ", skype.User().Handle
      
        attrs = { "identifier" : self.chat_message.ChatName,
                  "source" : "Skype",
                  "users" : [],
                  "content": from_name + " [ " + at_time + " ]: " + self.chat_message.Body,
                  "project_user" : skype.User().Handle
                }

        for user in self.chat_message.Chat.Members:
            attrs["users"].append(user.Handle)
        
        return simplejson.dumps(urllib.urlencode(attrs))

        

# instatinate Skype object and set our event handlers
skype = Skype4Py.Skype()
skype.Attach()

skype.OnUserStatus = user_status
skype.OnMessageStatus = message_status

# obtain reference to Application object
app = skype.Application('App2AppServer')

# create application
app.Create()

# wait forever until Ctrl+C (SIGINT) is issued
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    pass

# delete application
app.Delete()
