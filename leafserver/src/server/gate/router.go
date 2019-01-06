package gate

import (
	"server/game"
	"server/msg"
)

func init() {
	// 这里指定消息 Hello 路由到 game 模块
	msg.Processor.SetRouter(&msg.CUser{}, game.ChanRPC)
	msg.Processor.SetRouter(&msg.MoveDTO{}, game.ChanRPC)
	msg.Processor.SetRouter(&msg.PlaysResult{}, game.ChanRPC)
	msg.Processor.SetRouter(&msg.MoveResult{}, game.ChanRPC)
}
