from prisma import Prisma

class PrismaInstance : 
  def __init__(self):
    self.prismaConnected = False
    self.prisma = Prisma()
  
  async def connect(self):
    print("I am connecting")
    if self.prismaConnected : 
      return 
    
    await self.prisma.connect()
    self.prismaConnected = True
  
  async def createUser(self, userName: str, userEmail: str, userPicture: str):
    data = await self.prisma.user.create(
      data={
        'email': userEmail, 
        'name': userName, 
        'pictureUrl': userPicture
      }      
    )
    
    return "done"
  
  async def updateChat(self, chatId: str, chatMessage: str, src: str):
    await self.prisma.message.create(
      data={
        'chatId': chatId, 
        'message': chatMessage, 
        'source': src
      }
    )
  
  async def getChatData(self, userId):
    data = await self.prisma.chat.find_many(
      where={
          "userId": userId
      }, 
      include={
        'Messages': True
      }
    )
    
    return data