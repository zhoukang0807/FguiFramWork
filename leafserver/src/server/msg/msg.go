package msg

import (
	"github.com/name5566/leaf/network/protobuf"
)

// 使用 Protobuf 消息处理器
var Processor = protobuf.NewProcessor()

func init() {
	// 这里我们注册了消息 Hello
	Processor.Register(&CUser{})
}

 
type PlayerDTO struct{
	Id int
	UserName string
	Direct Vector2
	Point Vector3
}

type SessionUser struct{
	Playes map[int]*PlayerDTO
	Id      int
}
type SessionMove struct{
	Moves map[int]*MoveDTO
}

var(
	SessionUserServ = &SessionUser{make(map[int]*PlayerDTO), 0}
	SessionMoveServ = &SessionMove{make(map[int]*MoveDTO)}
)

func (this *SessionUser) AddUser(play *PlayerDTO) []*PlayerDTO {
	var players []*PlayerDTO
	var flag bool
	for _,iteam:=range this.Playes{
		players = append(players, iteam)
        if(play.UserName == iteam.UserName){
			flag = true
		}
	}
	if(!flag){
		this.Id +=1; 
		x:=float32(0)
		y:=float32(0)
		z:=float32(-1)
		palydto :=PlayerDTO{
			Id : this.Id,
	        Point : Vector3{X:&x,Y:&y,Z:&z},
		    UserName : play.UserName,
		}	
		this.Playes[this.Id] = &palydto;  
		players = append(players, &palydto)
	}
	return players
}
func (this *SessionUser) GetPlayes() []*PlayerDTO {
	var players []*PlayerDTO
	for _,iteam:=range this.Playes{
		players = append(players, iteam)
	}
	return players
}
func (this *SessionMove) GetMoves() []*MoveDTO {
	var moves []*MoveDTO
	for _,iteam:=range this.Moves{
		moves = append(moves, iteam)
	}
	return moves
}
func (this *SessionMove) SetMoves(move *MoveDTO) *MoveDTO {
	 id := int(*move.Id);
	 this.Moves[id] = move
	 return move
}