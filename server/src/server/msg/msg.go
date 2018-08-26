package msg

import (
	"reflect"

	"github.com/name5566/leaf/network/protobuf"
)

// 使用 Protobuf 消息处理器
var Processor = protobuf.NewProcessor()

func init() {
	// 这里我们注册了消息 Hello
	Processor.Register(&LoginRequest{})
	Processor.Register(&Location{})
	Processor.Register(&Person{})
	Processor.Range(get)
}

//此处输出proto的id
func get(id uint16, t reflect.Type) {

}
