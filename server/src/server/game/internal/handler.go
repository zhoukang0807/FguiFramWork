package internal

import (
	"reflect"
	"server/msg"

	"github.com/golang/protobuf/proto"
	"github.com/name5566/leaf/gate"
	"github.com/name5566/leaf/log"
)

func init() {
	// 向当前模块（game 模块）注册 Hello 消息的消息处理函数 handleHello
	handler(&msg.LoginRequest{}, handleHello)
	handler(&msg.Location{}, handleHello)
	handler(&msg.Person{}, handleHello)
}

func handler(m interface{}, h interface{}) {
	skeleton.RegisterChanRPC(reflect.TypeOf(m), h)
}

func handleHello(args []interface{}) {
	// 收到的 Hello 消息
	m := args[0].(*msg.Person)
	// 消息的发送者
	a := args[1].(gate.Agent)

	// 输出收到的消息的内容
	log.Debug("hello %v", m.GetId())

	// 给发送者回应一个 Hello 消息
	a.WriteMsg(&msg.Person{
		Id:    proto.Int32(11),
		Name:  proto.String("122"),
		Email: proto.String("1333"),
	})
}
