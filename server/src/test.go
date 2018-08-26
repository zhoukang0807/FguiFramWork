package main

import (
	"encoding/binary"
	"fmt"
	"net"
	"server/msg"

	"github.com/golang/protobuf/proto"
)

func main() {
	conn, err := net.Dial("tcp", "127.0.0.1:3080")
	if err != nil {
		panic(err)
	}
	test := &msg.Person{
		// 使用辅助函数设置域的值
		Id:    proto.Int32(11),
		Name:  proto.String("1"),
		Email: proto.String("1"),
	}
	// 进行编码
	data, err := proto.Marshal(test)
	if err != nil {
		fmt.Println("marshaling error: ", err)
	}
	// len + id + data
	m := make([]byte, 4+len(data))
	binary.LittleEndian.PutUint16(m, uint16(len(data)+2))
	buf := make([]byte, 2)
	buf[1] = 2
	copy(m[2:], buf)
	copy(m[4:], data)
	// 发送消息
	conn.Write(m)
}
