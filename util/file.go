package util

import (
	"encoding/hex"
	"io"
	"math"
	"mime/multipart"
	"os"

	"golang.org/x/crypto/blake2b"
)

const filechunk = 4096

//SaveFileTo 保存文件到目录
func SaveFileTo(fh *multipart.FileHeader, destDirectory string) (int64, error) {
	src, err := fh.Open()
	if err != nil {
		return 0, err
	}
	defer src.Close()

	out, err := os.OpenFile(destDirectory, os.O_WRONLY|os.O_CREATE, os.FileMode(0666))
	if err != nil {
		return 0, err
	}
	defer out.Close()

	return io.Copy(out, src)
}

// GetHash256 计算文件的hash值，采用blake2b算法。分片读取文件，性能比io.copy略高。
func GetHash256(filename string) (string, error) {
	// Open the file for reading
	file, err := os.Open(filename)
	if err != nil {
		return "", err
	}
	defer file.Close()

	// Get file info
	info, err := file.Stat()
	if err != nil {
		return "", err
	}

	// Get the filesize
	filesize := info.Size()

	// Calculate the number of blocks
	blocks := uint64(math.Ceil(float64(filesize) / float64(filechunk)))

	// Start hash
	hash, err := blake2b.New256(nil)
	if err != nil {
		return "", err
	}

	// Check each block
	for i := uint64(0); i < blocks; i++ {
		// Calculate block size
		blocksize := int(math.Min(filechunk, float64(filesize-int64(i*filechunk))))

		// Make a buffer
		buf := make([]byte, blocksize)

		// Make a buffer
		file.Read(buf)

		// Write to the buffer
		io.WriteString(hash, string(buf))
	}
	checksum := hex.EncodeToString(hash.Sum(nil))

	return checksum, nil
}

//ReadBigFile 分片读取大文件
func ReadBigFile(fileName string, handle func([]byte)) error {
	f, err := os.Open(fileName)
	if err != nil {
		return err
	}
	defer f.Close()
	s := make([]byte, filechunk)
	for {
		switch nr, err := f.Read(s[:]); true {
		case nr < 0:
			return err
		case nr == 0: // EOF
			return nil
		case nr > 0:
			handle(s[0:nr])
		}
	}
}
