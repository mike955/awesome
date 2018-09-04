package demochain

type Block struct {
	Index int64 //区块编号
	Timestamp int64	// 区块时间
	PreBlockHash string	// 上一个区块哈希值
	Hash string	//当前区块哈希值

	Data string	//区块数据
}

func calculateHash(b Block) string {
	blockData := string(b.Index) + b.Timestamp + b.PreBlockHash + b.Data
}