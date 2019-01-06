package internal

import (
	"github.com/name5566/leaf/gate"
	"server/msg"
)

func init() {
	skeleton.RegisterChanRPC("NewAgent", rpcNewAgent)
	skeleton.RegisterChanRPC("CloseAgent", rpcCloseAgent)
}

func rpcNewAgent(args []interface{}) {
	a := args[0].(gate.Agent)
	_ = a
}

func rpcCloseAgent(args []interface{}) {
	a := args[0].(gate.Agent)
	_ = a
	id, ok := a.UserData().(int32)
	if !ok {
		return
	}
	msg.SessionMoveServ.RemoveMove(id)
	msg.SessionUserServ.RemovePlayer(id)
}
