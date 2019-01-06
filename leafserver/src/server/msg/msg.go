package msg

import (
	"github.com/name5566/leaf/network/protobuf"
)

// 使用 Protobuf 消息处理器
var Processor = protobuf.NewProcessor()

func init() {
	// 这里我们注册了消息 Hello
	Processor.Register(&CUser{})
	Processor.Register(&MoveDTO{})
	Processor.Register(&PlaysResult{})
	Processor.Register(&MoveResult{})
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

func (this *SessionUser) AddUser(play *PlayerDTO) PlayerDTO {
	var players []*PlayerDTO
	var flag bool
	var player PlayerDTO
	for _,iteam:=range this.Playes{
		players = append(players, iteam)
        if(play.UserName == iteam.UserName){
			flag = true
			player= *play
		}
	}
	if(!flag){
		this.Id +=1;  
		palydto :=PlayerDTO{
			Id : int32(this.Id),
		    UserName : play.UserName,
		}	
		this.Playes[this.Id] = &palydto;  
		players = append(players, &palydto)
		player = palydto
	}
	return player
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
	 this.Moves[int(move.Id)] = move
	 return move
}

func (this *SessionMove) RemoveMove(id int32){
	delete(this.Moves, int(id))
}
func (this *SessionUser) RemovePlayer(id int32){
	delete(this.Playes, int(id))
}