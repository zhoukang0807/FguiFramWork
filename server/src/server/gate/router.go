package gate

import (
	"server/game"
	"server/msg"
)

func init() {
	// 这里指定消息 Hello 路由到 game 模块
	msg.Processor.SetRouter(&msg.LoginRequest{}, game.ChanRPC)
	msg.Processor.SetRouter(&msg.Location{}, game.ChanRPC)
	msg.Processor.SetRouter(&msg.Person{}, game.ChanRPC)
}
