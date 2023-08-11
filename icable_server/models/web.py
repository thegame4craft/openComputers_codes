from . import Model
from .user import Users,User
from random import getrandbits

class WebSessions(Model):

    def getSession(self,sid:int):
        """Return the user the session belong to or False"""
        cursor=self._database.execute("SELECT sid,login FROM sessions WHERE sid = ?",(sid,))
        res = cursor.fetchone()
        if(res):
            return Users(self._database).getUserFromLogin(res[1])
        else:
            return False
        
    def createSession(self,user:User):
        """Create a session for the user. Return the session id"""
        sid = getrandbits(32)
        self._database.execute("INSERT INTO sessions VALUES (?,?)",(sid,user.login))
        self._database.commit()
        return sid
    
    def deleteSession(self,sid:int):
        self._database.execute("DELETE FROM sessions WHERE sid = ?",(sid,))
        self._database.commit()