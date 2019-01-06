package internal

import (
	"reflect"
	"server/msg"
	"github.com/name5566/leaf/gate"
	"github.com/name5566/leaf/log"
)

func init() {
	// 向当前模块（game 模块）注册 Hello 消息的消息处理函数 handleHello
	handler(&msg.CUser{}, handleHello)
	handler(&msg.MoveDTO{}, handleMove)
	handler(&msg.PlaysResult{}, handleGetPlayes)
	handler(&msg.MoveResult{}, handleGetMoves)
}

func handler(m interface{}, h interface{}) {
	skeleton.RegisterChanRPC(reflect.TypeOf(m), h)
}

func handleHello(args []interface{}) {
	// 收到的 Hello 消息
	m := args[0].(*msg.CUser)
	// 消息的发送者
	a := args[1].(gate.Agent)
	
	var play msg.PlayerDTO 
	play.UserName = m.GetUsername()
	var player msg.PlayerDTO
	player = msg.SessionUserServ.AddUser(&play)

	a.SetUserData(player.Id)
	// 输出收到的消息的内容
	log.Debug("hello %v", m.GetUsername())
 
	// 给发送者回应一个 Hello 消息
	a.WriteMsg(&msg.CUser{
		Id: player.Id,
		Username:player.GetUserName(),
	})
}
func handleMove(args []interface{}) {
	// 收到的 Hello 消息
	m := args[0].(*msg.MoveDTO)
	// 消息的发送者
	a := args[1].(gate.Agent)
 
	log.Debug("坐标", m.GetPoint())
	// 输出收到的消息的内容
	log.Debug("id", m.GetId())
	move:=msg.SessionMoveServ.SetMoves(m)
	// 给发送者回应一个 Hello 消息
	a.WriteMsg(move)
}

func handleGetPlayes(args []interface{}) {
	// 收到的 Hello 消息
	// m := args[0].(*msg.PlaysResult)
	// 消息的发送者
	a := args[1].(gate.Agent)
 
	var plays []*msg.PlayerDTO

	plays = msg.SessionUserServ.GetPlayes()

	log.Debug("共有", len(plays),"玩家在线")

	// 给发送者回应一个 Hello 消息
	a.WriteMsg(&msg.PlaysResult{
		Playes : plays,
	})
}

func handleGetMoves(args []interface{}) {
	// 收到的 Hello 消息
	// m := args[0].(*msg.MoveResult)
	// 消息的发送者
	a := args[1].(gate.Agent)
 
	var moves []*msg.MoveDTO
 
    moves = msg.SessionMoveServ.GetMoves()

	// 给发送者回应一个 Hello 消息
	a.WriteMsg(&msg.MoveResult{
		Moves : moves,
	})
}